cd /home/testadmin/
sudo git clone "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow" objectdetection
cd ./objectdetection/
sudo dotnet publish

sudo cp -a ./objectdetection/bin/Debug/netcoreapp2.0/publish /home/testadmin/temp
sudo rm -r /home/testadmin/objectdetection/*
sudo cp -a /home/testadmin/temp/* /home/testadmin/objectdetection/

wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/libtensorflow.so"

sudo apt-get -y install nginx
sudo service nginx start

cd /etc/nginx/sites-available/
wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/default"

sudo nginx -t 
sudo nginx -s reload

sudo apt-get -y install supervisor
