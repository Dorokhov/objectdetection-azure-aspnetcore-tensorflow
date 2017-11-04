sudo pip3 install pillow
sudo pip3 install lxml

sudo apt-get -y install unzip
sudo apt-get -y install protobuf-compiler python-pil python-lxml
sudo pip install jupyter
sudo pip install matplotlib

cd /usr/local/lib/python3.4/dist-packages/tensorflow/
sudo mkdir protoc_3.3
cd protoc_3.3
sudo wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip
sudo chmod 775 protoc-3.3.0-linux-x86_64.zip
sudo unzip protoc-3.3.0-linux-x86_64.zip


cd /home/testadmin/
mkdir training
cd training
git clone https://github.com/Dorokhov/models
cd models/research
/usr/local/lib/python3.4/dist-packages/tensorflow/protoc_3.3/bin/protoc object_detection/protos/*.proto --python_out=.


cd object_detection/samples/configs
wget -N "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/faster_rcnn_resnet101_coco.config"

cd /home/testadmin
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/train.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/start_tensorboard.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/move_model.sh"
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/eval.sh"

cd /home/testadmin/training/models/research
mkdir train
mkdir eval

cd train
wget "http://download.tensorflow.org/models/object_detection/faster_rcnn_resnet101_coco_11_06_2017.tar.gz"
tar -xzvf faster_rcnn_resnet101_coco_11_06_2017.tar.gz
cp -a /home/testadmin/training/models/research/train/faster_rcnn_resnet101_coco_11_06_2017/* /home/testadmin/training/models/research/train

cd /home/testadmin/training/models/research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

sudo wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/images.tar.gz
wget http://www.robots.ox.ac.uk/~vgg/data/pets/data/annotations.tar.gz
tar -xvf annotations.tar.gz
tar -xvf images.tar.gz
python3 object_detection/create_pet_tf_record.py --label_map_path=object_detection/data/pet_label_map.pbtxt --data_dir=`pwd` --output_dir=`pwd`

