cd $MODELS_PATH
sh export_variables.sh
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/eval.py --logtostderr --pipeline_config_path=train/$CONFIG_NAME --checkpoint_dir=train --eval_dir=eval