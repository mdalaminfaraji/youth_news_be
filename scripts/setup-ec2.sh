#!/bin/bash

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 globally
sudo npm install -g pm2

# Install Nginx
sudo apt-get install -y nginx

# Configure Nginx
sudo bash -c 'cat > /etc/nginx/sites-available/youth-media <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:1337;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF'

# Enable Nginx configuration
sudo ln -s /etc/nginx/sites-available/youth-media /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Create project directory
sudo mkdir -p /var/www/youth-media
sudo chown -R $USER:$USER /var/www/youth-media
sudo chmod -R 755 /var/www

# Install project dependencies
cd /var/www/youth-media
git clone https://github.com/YOUR_GITHUB_USER/YOUR_REPO_NAME.git .
yarn install

# Start application with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup
