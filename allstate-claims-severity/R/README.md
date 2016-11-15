# Using R in a server

Included in this folder you will find a script to automate the installation of RStudio Server on a DO droplet in `install-rserver.sh`

## How to use it

- Create a droplet in DigitalOcean (where I have tested this)
  - Used an Ubuntu 16.04 droplet with this features: 16 GB / 8 CPUs /160 GB SSD disk / 6 TB transfer
- Login using SSH
- Copy-paste the code into a file and execute it
- Upload to the server your datasets
- Access the RS Server using the IP assigned by DO and the port 8787: http//<droplet-ip>:8787/
- Start using the power of the droplet!

## How to control the RS Server?
```sh
# Kill the server
sudo rstudio-server stop
# Start the server
sudo rstudio-server start
# Restart the server
sudo rstudio-server restart
```

If you have the problem of some locale issue or something, probably you haven't closed and opened a new terminal window.

## How to sync files to the droplet
```sh
rsync -rave "ssh -i ~/.ssh/id_rsa" <source-data> <your-user>@<droplet-ip>:<folder-destination>
# Example. If you followed the previous steps, it will ask for the password you inputed in the installation script
rsync -rave "ssh" /Users/myuser/Downloads/datasets/* rUser@100.128.170.2:/home/r_user/datasets
```
