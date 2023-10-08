#!/usr/bin/env bash
# Sets up web servers for the deployment of web_static

apt-get -y update > /dev/null
apt-get install -y nginx > /dev/null

# Creates all necessary directories and files
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/
touch /data/web_static/releases/test/index.html
echo "Hello World again!" > /data/web_static/releases/test/index.html

# Checks if directory current exists
if [ -d "/data/web_static/current" ]
then
        sudo rm -rf /data/web_static/current
fi

# Create a symbolic link to test
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Changes ownership to user ubuntu
chown -hR ubuntu:ubuntu /data

# Configures nginx to serve content pointed to by symbolic link to hbnb_static
sed -i '38i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

# Restart servers
service nginx restart
