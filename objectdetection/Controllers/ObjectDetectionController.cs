using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using Microsoft.AspNetCore.Http.Extensions;

namespace objectdetection.Controllers
{
    [Route("api/[controller]")]
    public class ObjectDetectionController : Controller
    {
        private const string TrainedModelFileName = "frozen_inference_graph.pb"; // "trained_model.pb";
        private const string CatalogFileName = "mscoco_label_map.pbtxt"; //"labels.pbtxt";

        private ILogger<ObjectDetectionController> _logger;
        private readonly IHostingEnvironment _hostingEnvironment;

        public ObjectDetectionController(ILogger<ObjectDetectionController> logger, IHostingEnvironment hostingEnvironment)
        {
            _logger = logger;
            _hostingEnvironment = hostingEnvironment;
        }

        [HttpGet("{id}")]
        public IActionResult GetProcessedImageById(string id)
        {
            if (id == null) throw new ArgumentNullException(nameof(id));
            var image = System.IO.File.OpenRead($"test_images/{id}_detected.jpg");
            return File(image, "image/jpeg");
        }

        [HttpPut("{id}")]
        public void Train(string config = "ssd_mobilenet_v1_pets.config")
        {
            try
            {
                ("cd /home/testadmin/training/models/research" + Environment.NewLine +
                 $"export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim" + Environment.NewLine +
                 $"python3 object_detection/train.py --logtostderr --pipeline_config_path=object_detection/samples/configs/{config} --train_dir=train").Bash();

                foreach (var filePath in Directory.GetFiles("/home/testadmin/training/models/research/"))
                {
                    var extension = Path.GetExtension(filePath);
                    if (extension == "pb")
                    {
                        System.IO.File.Move(filePath, Path.Combine(_hostingEnvironment.ContentRootPath, TrainedModelFileName));
                    }
                    else if (extension == "pbtxt")
                    {
                        System.IO.File.Move(filePath, Path.Combine(_hostingEnvironment.ContentRootPath, CatalogFileName));
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Training failed");
                throw;
            }
        }

        [HttpPost]
        public (string, string) DetectImage([FromBody]string imageAsString)
        {
            if (imageAsString == null) throw new ArgumentNullException(nameof(imageAsString));

            // generate input and processed file names
            string id = Guid.NewGuid().ToString("N");
            string inputImage = GetSafeFilename($"{id}.jpg");
            string outputImage = GetSafeFilename($"{id}_detected.jpg");

            string inputImagePath = Path.Combine(_hostingEnvironment.ContentRootPath, "test_images", inputImage);
            string outputImagePath = Path.Combine(_hostingEnvironment.ContentRootPath, "test_images", outputImage);

            // save input image on the disk
            SaveImage(imageAsString, inputImagePath);

            // run tensorflow and detect objects on the image
            ExampleObjectDetection.Program.Main(new string[] {
                $@"--input_image={inputImagePath}",
                $@"--output_image={outputImagePath}" ,
                $@"--catalog={Path.Combine(_hostingEnvironment.ContentRootPath,CatalogFileName)}" ,
                $@"--model={Path.Combine(_hostingEnvironment.ContentRootPath,TrainedModelFileName)}" ,
            },
                _logger);

            // return processed image and url for preview 
            string detectedImage = Convert.ToBase64String(System.IO.File.ReadAllBytes(outputImagePath));
            var previewUrl = UriHelper.BuildAbsolute(Request.Scheme, Request.Host, path: new Microsoft.AspNetCore.Http.PathString($"/api/objectdetection/{id}"));
            return (previewUrl, detectedImage);
        }

        private static void SaveImage(string imgStr, string imgPath)
        {
            byte[] imageBytes = Convert.FromBase64String(imgStr);
            System.IO.File.WriteAllBytes(imgPath, imageBytes);
        }

        private string GetSafeFilename(string filename)
        {
            return string.Join("_", filename.Split(Path.GetInvalidFileNameChars()));
        }
    }
}
