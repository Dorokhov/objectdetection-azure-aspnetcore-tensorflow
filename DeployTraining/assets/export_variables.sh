export TRAIN_PATH=/home/testadmin/training/models/research/train
export MODELS_PATH=/home/testadmin/training/models/research
export PRETRAINED_MODEL_NAME=faster_rcnn_resnet101_coco_11_06_2017
export MODELS_REPO=https://github.com/Dorokhov/models

#export OBJECT_LABELS=pet_label_map.pbtxt
export OBJECT_LABELS=pascal_label_map.pbtxt

#export CREATE_RECORD_FILE=create_pet_tf_record.py
export CREATE_RECORD_FILE=create_pascal_tf_record.py

export CONFIG_NAME=ssd_mobilenet_v1_coco.config