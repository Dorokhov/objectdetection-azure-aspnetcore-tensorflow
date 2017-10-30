cd /home/testadmin/training/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/eval.py --logtostderr --pipeline_config_path=object_detection/samples/configs/faster_rcnn_resnet101_pets.config --checkpoint_dir=train --eval_dir=eval