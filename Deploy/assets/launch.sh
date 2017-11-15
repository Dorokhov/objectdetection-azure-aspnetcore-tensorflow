cd /home/testadmin/
git clone "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow" objectdetection
cd ./objectdetection/
sudo dotnet publish

cp -a ./objectdetection/bin/Debug/netcoreapp2.0/publish /home/testadmin/temp
sudo rm -r /home/testadmin/objectdetection/*
cp -a /home/testadmin/temp/* /home/testadmin/objectdetection/

wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/libtensorflow.so"

sudo apt-get -y install nginx
sudo service nginx start

cd /etc/nginx/sites-available/
sudo wget -q "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/default" -O default
sudo cp -rf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/

sudo nginx -t 
sudo nginx -s reload

sudo apt-get -y install supervisor
cd /etc/supervisor/conf.d/
sudo wget -q "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/dotnettest.conf" -O dotnettest.conf
sudo service supervisor stop
sudo service supervisor start

cd /home/testadmin
wget "http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_coco_2017_11_08.tar.gz"
tar -xzvf ssd_mobilenet_v1_coco_2017_11_08.tar.gz
cp -a ssd_mobilenet_v1_coco_2017_11_08/frozen_inference_graph.pb objectdetection/
cp -a training/models/research/object_detection/data/pascal_label_map.pbtxt objectdetection