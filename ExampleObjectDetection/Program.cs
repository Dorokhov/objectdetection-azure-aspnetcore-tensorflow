﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using TensorFlow;
using ExampleCommon;
using Mono.Options;
using System.Reflection;
using System.Net;
using ICSharpCode.SharpZipLib.Tar;
using ICSharpCode.SharpZipLib.GZip;
using System.Drawing;
using Microsoft.Extensions.Logging;

namespace ExampleObjectDetection
{
	public class Program
	{
		private static IEnumerable<CatalogItem> _catalog;
		private static string _currentDir = Path.GetDirectoryName (Assembly.GetExecutingAssembly ().Location);
		private static string _input = Path.Combine (_currentDir, "test_images/input.jpg");
		private static string _output = Path.Combine (_currentDir, "test_images/output.jpg");
		private static string _catalogPath;
		private static string _modelPath;

		private static double MIN_SCORE_FOR_OBJECT_HIGHLIGHTING = 0.5;

		static OptionSet options = new OptionSet ()
		{
			{ "input_image=",  "Specifies the path to an image ", v => _input = v },
			{ "output_image=",  "Specifies the path to the output image with detected objects", v => _output = v },
			{ "catalog=", "Specifies the path to the .pbtxt objects catalog", v=> _catalogPath = v},
			{ "model=", "Specifies the path to the trained model", v=> _modelPath = v},
			{ "h|help", v => Help () }
		};

		/// <summary>
		/// Run the ExampleObjectDetection util from command line. Following options are available:
		/// input_image - optional, the path to the image for processing (the default is 'test_images/input.jpg')
		/// output_image - optional, the path where the image with detected objects will be saved (the default is 'test_images/output.jpg')
		/// catalog - optional, the path to the '*.pbtxt' file (by default, 'mscoco_label_map.pbtxt' been loaded)
		/// model - optional, the path to the '*.pb' file (by default, 'frozen_inference_graph.pb' model been used, but you can download any other from here 
		/// https://github.com/tensorflow/models/blob/master/object_detection/g3doc/detection_model_zoo.md or train your own)
		/// 
		/// for instance, 
		/// ExampleObjectDetection --input_image="/demo/input.jpg" --output_image="/demo/output.jpg" --catalog="/demo/mscoco_label_map.pbtxt" --model="/demo/frozen_inference_graph.pb"
		/// </summary>
		/// <param name="args"></param>
		public static void Main<T> (string [] args, ILogger<T> logger)
		{
			options.Parse (args);

			if (_catalogPath == null) {
				_catalogPath = DownloadDefaultTexts (_currentDir);
			}

			if (_modelPath == null) {
				_modelPath = DownloadDefaultModel (_currentDir);
			}

			_catalog = CatalogUtil.ReadCatalogItems (_catalogPath);
			var fileTuples = new List<(string input, string output)> () { (_input, _output) };
			string modelFile = _modelPath;

            logger.LogDebug("running tensorflow");

            using (var graph = new TFGraph ())
            {
                logger.LogDebug("tensorflow graph created");
                var model = File.ReadAllBytes (modelFile);
				graph.Import (new TFBuffer (model));

                logger.LogDebug("tensorflow model imported");

                using (var session = new TFSession (graph)) {
					foreach (var tuple in fileTuples) {
						var tensor = ImageUtil.CreateTensorFromImageFile (tuple.input, TFDataType.UInt8);
						var runner = session.GetRunner ();
                        
                        runner
							.AddInput (graph ["image_tensor"] [0], tensor)
							.Fetch (
							graph ["detection_boxes"] [0],
							graph ["detection_scores"] [0],
							graph ["detection_classes"] [0],
							graph ["num_detections"] [0]);

                        logger.LogDebug("before session run");
                        var output = runner.Run ();
                        logger.LogDebug("session run finished");

                        var boxes = (float [,,])output [0].GetValue (jagged: false);
						var scores = (float [,])output [1].GetValue (jagged: false);
						var classes = (float [,])output [2].GetValue (jagged: false);
						var num = (float [])output [3].GetValue (jagged: false);

                        logger.LogDebug("drawing boxes");
                        DrawBoxes (boxes, scores, classes, tuple.input, tuple.output, MIN_SCORE_FOR_OBJECT_HIGHLIGHTING);
                        logger.LogDebug("boxes are drawn");
                    }
				}
            }

            logger.LogDebug("tensorflow object detection completed");
        }

		private static string DownloadDefaultModel (string dir)
		{
			const string defaultModelUrl = "http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017.tar.gz";

			var modelFile = Path.Combine (dir, "faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017/frozen_inference_graph.pb");
			var zipfile = Path.Combine (dir, "faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017.tar.gz");

			if (File.Exists (modelFile))
				return modelFile;

			if (!File.Exists (zipfile)) {
				var wc = new WebClient ();
				wc.DownloadFile (defaultModelUrl, zipfile);
			}

			ExtractToDirectory (zipfile, dir);
			File.Delete (zipfile);

			return modelFile;
		}

		private static void ExtractToDirectory (string file, string targetDir)
		{
			using (Stream inStream = File.OpenRead (file))
			using (Stream gzipStream = new GZipInputStream (inStream)) {
				TarArchive tarArchive = TarArchive.CreateInputTarArchive (gzipStream);
				tarArchive.ExtractContents (targetDir);
			}
		}

		private static string DownloadDefaultTexts (string dir)
		{
			const string defaultTextsUrl = "https://raw.githubusercontent.com/tensorflow/models/master/research/object_detection/data/mscoco_label_map.pbtxt";
			var textsFile = Path.Combine (dir, "mscoco_label_map.pbtxt");
			var wc = new WebClient ();
			wc.DownloadFile (defaultTextsUrl, textsFile);

			return textsFile;
		}

		private static void DrawBoxes (float [,,] boxes, float [,] scores, float [,] classes, string inputFile, string outputFile, double minScore)
		{
			var x = boxes.GetLength (0);
			var y = boxes.GetLength (1);
			var z = boxes.GetLength (2);

			float ymin = 0, xmin = 0, ymax = 0, xmax = 0;

			using (var editor = new ImageEditor (inputFile, outputFile)) {
				for (int i = 0; i < x; i++) {
					for (int j = 0; j < y; j++) {
						if (scores [i, j] < minScore) continue;

						for (int k = 0; k < z; k++) {
							var box = boxes [i, j, k];
							switch (k) {
							case 0:
								ymin = box;
								break;
							case 1:
								xmin = box;
								break;
							case 2:
								ymax = box;
								break;
							case 3:
								xmax = box;
								break;
							}

						}

						int value = Convert.ToInt32 (classes [i, j]);
						CatalogItem catalogItem = _catalog.FirstOrDefault (item => item.Id == value);
						editor.AddBox (xmin, xmax, ymin, ymax, $"{catalogItem.DisplayName} : {(scores [i, j] * 100).ToString ("0")}%");
					}
				}
			}
		}

		private static void Help ()
		{
			options.WriteOptionDescriptions (Console.Out);
		}
	}
}
