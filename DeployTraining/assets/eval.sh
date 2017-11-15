. export_variables.sh
cd $MODELS_PATH
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
python3 object_detection/eval.py --logtostderr --pipeline_config_path=train/$CONFIG_NAME --checkpoint_dir=train --eval_dir=eval