cd /home/testadmin/
sudo git clone "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow"
cd ./objectdetection/
sudo dotnet publish

sudo cp -a ./objectdetection/bin/Debug/netcoreapp2.0/publish /home/testadmin/temp
sudo rm -r /home/testadmin/objectdetection/*
sudo cp -a /home/testadmin/temp/* /home/testadmin/objectdetection/

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
sudo wget -q "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/default" -O
sudo service supervisor stop
sudo service supervisor start