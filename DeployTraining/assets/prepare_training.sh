sudo pip3 install pillow
sudo pip3 install lxml

sudo apt-get -y install unzip
sudo apt-get -y install protobuf-compiler python-pil python-lxml
sudo pip install jupyter
sudo pip install matplotlib

cd /usr/local/lib/python3.5/dist-packages/tensorflow/
sudo mkdir protoc_3.3
cd protoc_3.3
sudo wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip
sudo chmod 775 protoc-3.3.0-linux-x86_64.zip
sudo unzip protoc-3.3.0-linux-x86_64.zip


cd /home/testadmin/
mkdir training
cd training
git clone $MODELS_REPO

cd $MODELS_PATH
/usr/local/lib/python3.5/dist-packages/tensorflow/protoc_3.3/bin/protoc object_detection/protos/*.proto --python_out=.


cd object_detection/samples/configs
sh export_variables.sh
wget -N "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/$CONFIG_NAME"

cd /home/testadmin
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/train.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/start_tensorboard.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/move_model.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/eval.sh"

wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/install_cuda.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/install_cudnn.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/DeployTraining/assets/install_driver.sh"

cd $MODELS_PATH
mkdir train
mkdir eval

cd train
wget "http://storage.googleapis.com/download.tensorflow.org/models/object_detection/$(PRETRAINED_MODEL_NAME).tar.gz"
tar -xzvf $(PRETRAINED_MODEL_NAME).tar.gz
cp -a $MODELS_PATH/train/$(PRETRAINED_MODEL_NAME)/model.ckpt.* $MODELS_PATH/train

cd $MODELS_PATH
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

# PET
#sudo wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/images.tar.gz
#wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/annotations.tar.gz
#tar -xvf annotations.tar.gz -C train
#tar -xvf images.tar.gz -C train
#python3 object_detection/$CREATE_RECORD_FILE --label_map_path=object_detection/data/$OBJECT_LABELS --data_dir=train --output_dir=train

# COCO
wget http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar
tar -xvf VOCtrainval_11-May-2012.tar -C train
python3 object_detection/$CREATE_RECORD_FILE --label_map_path=object_detection/data/$OBJECT_LABELS --data_dir=train/VOCdevkit --year=VOC2012 --set=train --output_path=train/pascal_train.record
python3 object_detection/$CREATE_RECORD_FILE --label_map_path=object_detection/data/$OBJECT_LABELS --data_dir=train/VOCdevkit --year=VOC2012 --set=val --output_path=train/pascal_val.record

cp -a $MODELS_PATH/object_detection/data/$OBJECT_LABELS $MODELS_PATH/train
cp -a $MODELS_PATH/object_detection/samples/configs/CONFIG_NAME $TRAIN_PATH