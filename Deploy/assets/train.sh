cd /home/testadmin/training/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/train.py --logtostderr --pipeline_config_path=object_detection/samples/configs/ssd_mobilenet_v1_pets.config --train_dir=train