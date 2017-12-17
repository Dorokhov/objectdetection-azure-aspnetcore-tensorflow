. export_variables.sh
cd $MODELS_PATH
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/dataset_tools/$CREATE_RECORD_FILE --label_map_path=object_detection/data/$OBJECT_LABELS --data_dir=train/VOCdevkit --year=VOC2012 --set=train --output_path=train/mscoco_train.record
python3 object_detection/dataset_tools/$CREATE_RECORD_FILE --label_map_path=object_detection/data/$OBJECT_LABELS --data_dir=train/VOCdevkit --year=VOC2012 --set=val --output_path=train/mscoco_val.record