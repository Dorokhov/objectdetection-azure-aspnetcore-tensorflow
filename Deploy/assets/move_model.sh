cd /home/testadmin/training/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/export_inference_graph.py --input_type image_tensor --pipeline_config_path object_detection/samples/configs/ssd_mobilenet_v1_pets.config --trained_checkpoint_prefix train --output_directory frozen_inference_graph.pb
cp -a ./train/frozen_inference_graph.pb /home/testadmin/objectdetection
cd /home/testadmin/objectdetection
wget -N "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/ssd_mobilenet_v1_pets.config"