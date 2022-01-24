#!/bin/bash

# nginx install
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# configure reverse proxy
sudo cp ./config/front.conf /etc/nginx/sites-available/front
sudo cp ./config/back.conf /etc/nginx/sites-available/back

sudo ln -s /etc/nginx/sites-available/front /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/back /etc/nginx/sites-enabled

# nginx service
sudo nginx -t
sudo nginx -s reload

# certbot install
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# certbot get certificate
sudo certbot --nginx