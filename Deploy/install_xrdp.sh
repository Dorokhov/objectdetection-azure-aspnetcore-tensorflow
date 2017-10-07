#!/bin/bash
sudo apt-get update
#install gnome desktop
#sudo apt-get install ubuntu-desktop -y
#install xrdp
sudo apt-get install xrdp -y

#using xfce if you are using Ubuntu version later than Ubuntu 12.04LTS
sudo apt-get install xfce4 -y
#sudo apt-get install xubuntu-desktop -y
sudo echo xfce4-session >/root/.xsession
sudo sed -i '/\/etc\/X11\/Xsession/i xfce4-session' /etc/xrdp/startwm.sh
sudo service xrdp restart

#text editor
#sudo apt-get -y install cream
#sudo apt-get -y install chromium-browser

#install gdi
#sudo apt-get -y install libgdiplus

#install git
#sudo apt-get -y install git

#install tensorflow
#cd ~/
#sudo apt-get -y install python3-setuptools
#sudo easy_install3 pip
#sudo pip3 install --upgrade pip wheel setuptools
#sudo apt-get -y install python-pip python-dev
#sudo pip install tensorflow

#install dotnet core
#curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
#sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

#sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list'

#sudo apt-get update
#sudo apt-get -y install dotnet-sdk-2.0.0
