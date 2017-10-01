cd /home/testadmin/
sudo git clone "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow"
cd ./objectdetection/
sudo dotnet publish
cd /bin/Debug/netcoreapp2.0

sudo cp -a ./bin/Debug/netcoreapp2.0 /home/testadmin/temp
sudo rm /home/testadmin/objectdetection/*
sudo cp -a /home/testadmin/temp /home/testadmin/objectdetection/

wget "https://github.com/Dorokhov/objectdetection-azure-aspnetcore-tensorflow/raw/master/Deploy/assets/libtensorflow.so"

sudo apt-get -y install nginx
sudo service nginx start

cd /etc/nginx/

sudo nginx -t 
sudo nginx -s reload

sudo apt-get -y install supervisor