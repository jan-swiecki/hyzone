#!/bin/bash

sudo apt-get install -y build-essential checkinstall
mkdir -p ~/python-install
cd ~/python-install
wget https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tar.xz
tar xJf ./Python-3.5.1.tar.xz
cd ./Python-3.5.1
./configure --prefix=/opt/python3.5 --with-ensurepip=install
make && sudo make install
sudo ln -s /opt/python3.5/bin/python3 /usr/local/bin/python
sudo ln -s /opt/python3.5/bin/pip3 /usr/local/bin/pip
sudo pip install --upgrade pip
cd ~
sudo rm -rf python-install