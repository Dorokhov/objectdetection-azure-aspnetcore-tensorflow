. export_variables.sh
cd $MODELS_PATH
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 $MODELS_PATH/object_detection/train.py --logtostderr --pipeline_config_path=train/$CONFIG_NAME --train_dir=train