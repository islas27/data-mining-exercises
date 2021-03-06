#!/usr/bin/env bash

# Add the R mirror in the droplet
echo "deb http://lib.stat.cmu.edu/R/CRAN/bin/linux/ubuntu xenial/ " >> /etc/apt/sources.list
#echo "deb http://lib.stat.cmu.edu/R/CRAN/bin/linux/ubuntu yakkety/ " >> /etc/apt/sources.list
# Add the key to be able to doenload from here
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
# Upgrade the ubuntu server software to the latest versions and install software
apt update && apt upgrade -y && apt install gdebi-core libcurl4-openssl-dev libssl-dev libssh2-1-dev r-base -y
# Set the locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
echo "export LANG=en_US.UTF-8" >> .bashrc
echo "export LC_ALL=en_US.UTF-8" >> .bashrc
# Optionaly, Install RStudio Server
# sudo apt install gdebi-core
# wget https://download2.rstudio.org/rstudio-server-1.0.44-amd64.deb
# sudo gdebi rstudio-server-1.0.44-amd64.deb
# Prepare a new user capable of using the RS server
# useradd -m -d /home/r_user -s /bin/bash -c "R Studio User"  -U rUser
# passwd rUser
# To user the readr package, you need this curl

echo "############# IMPORTANT MESSAGE ###############"
echo "Preferrably, after settign this up, close the terminal and open it again, so some changes can take full effect"
