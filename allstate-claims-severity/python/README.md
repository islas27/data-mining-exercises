# Using Python in a server

Included in this folder you will find a script to automate the installation of python dependencies or everything else needed to use the scripts found here. The script is called `install-environment.sh`

## How to use it

- Create a droplet in DigitalOcean (where I have tested this)
  - Used an Ubuntu 16.04 droplet with this features: 16 GB / 8 CPUs /160 GB SSD disk / 6 TB transfer
- Login using SSH
- Copy-paste the code into a file and execute it or just copy line by line
- Upload to the server your datasets
- (If Installed)Access the RS Server using the IP assigned by DO and the port 8787: http//<droplet-ip>:8787/
- Start using the power of the droplet!

## How to sync files to the droplet
```sh
rsync -rave "ssh -i ~/.ssh/id_rsa" <source-data> <your-user>@<droplet-ip>:<folder-destination>
# Example. If you followed the previous steps, it will ask for the password you inputed in the installation script
rsync -rave "ssh -i ~/.ssh/id_rsa" /Users/islas/datasets/* rUser@10.10.10.3:/home/r_user/datasets
```

## Tips for working with a remote server
- Use `tmux` for working with the consoles of the programming languages like R or python
  - You will be able to detach the terminal session, log out of ssh, and at a later point reattach it and continue  working where you left it before
- Terminal is your best friend
  - A lot of GUI tools may make it easier to start using software, but will become a crutch in the long run
  - Some libraries do not play well with GUI environments because of the use of threading
