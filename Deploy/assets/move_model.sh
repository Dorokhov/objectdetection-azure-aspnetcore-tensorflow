cd /home/testadmin/training/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/export_inference_graph.py --input_type image_tensor --pipeline_config_path object_detection/samples/configs/faster_rcnn_resnet101_coco.config --trained_checkpoint_prefix train/model.ckpt-0 --output_directory frozen_inference_graph.pb
cp -a ./frozen_inference_graph.pb/frozen_inference_graph.pb /home/testadmin/objectdetection
cd /home/testadmin/objectdetection
wget -N "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/pet_label_map.pbtxt"