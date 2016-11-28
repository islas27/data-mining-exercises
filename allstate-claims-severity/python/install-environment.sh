#!/usr/bin/env bash
# Set system language variables
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
echo "export LANG=en_US.UTF-8" >> .bashrc
echo "export LC_ALL=en_US.UTF-8" >> .bashrc

# Install missing software
apt install unzip g++ make python-pip python-dev build-essential python-setuptools

# Upgrading python env and installing libraries
pip install --upgrade pip
pip install --upgrade virtualenv
pip install pandas sklearn scipy

# Install xgboost library globally
git clone --recursive https://github.com/dmlc/xgboost
cd xgboost; make -j4
cd python-package; sudo python setup.py install

# Ready to crunch!
# python
