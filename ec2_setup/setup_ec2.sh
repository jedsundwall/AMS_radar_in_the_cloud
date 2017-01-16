#!/usr/bin/env bash
#Code adapted from https://gist.github.com/yangj1e/3641843c758201ebbc6c (Modified to Python3.5)

cd ~
#wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.4.0-Linux-x86_64.sh
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
bash Anaconda3-4.2.0-Linux-x86_64.sh -b
echo 'PATH="/home/ubuntu/anaconda3/bin:$PATH"' >> .bashrc
. .bashrc

conda update conda

#provision 

conda install -y basemap scipy cartopy boto netCDF4

git clone https://github.com/ARM-DOE/pyart

cd ~/pyart

python setup.py install

jupyter notebook --generate-config

echo "ENTER YOUR PASSWORD"

key=$(python -c "from notebook.auth import passwd; print(passwd())")

cd ~
mkdir certs
cd certs
certdir=$(pwd)

echo "IF YOU WANT, ENTER YOUR DETAILS OR JUST PRESS ENTER"

openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.key -out mycert.pem

cd ~
sed -i "1 a\
c = get_config()\\
c.NotebookApp.certfile = u'$certdir/mycert.pem'\\
c.NotebookApp.ip = '*'\\
c.NotebookApp.open_browser = False\\
c.NotebookApp.password = u'$key'\\
c.NotebookApp.port = 8888" .jupyter/jupyter_notebook_config.py
