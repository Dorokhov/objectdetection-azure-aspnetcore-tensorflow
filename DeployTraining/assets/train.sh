cd $MODELS_PATH
sh export_variables.sh
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/train.py --logtostderr --pipeline_config_path=train/$CONFIG_NAME --train_dir=train