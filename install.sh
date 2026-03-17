#!/bin/bash
# TrackDirect Auto-Installer (qvarforth fork)

set -e

echo "--- Installing Stack ---"
sudo apt-get update
sudo apt-get install -y git postgresql apache2 php php-pgsql python3-pip python3-dev libpq-dev

echo "--- Cloning TrackDirect ---"
sudo mkdir -p /opt/trackdirect
sudo git clone https://github.com/qvarforth/trackdirect.git /opt/trackdirect
cd /opt/trackdirect

echo "--- Database Setup ---"
# Create DB and User
sudo -u postgres psql -c "CREATE DATABASE trackdirect ENCODING 'UTF8';"
sudo -u postgres psql -c "CREATE USER database_user WITH PASSWORD 'database_password' SUPERUSER;"

# Run the schema import
sudo chmod +x /opt/trackdirect/server/scripts/db_setup.sh
sudo /opt/trackdirect/server/scripts/db_setup.sh trackdirect 5432 /opt/trackdirect/misc/database/tables

echo "--- Python Requirements ---"
sudo pip3 install -r requirements.txt --break-system-packages || sudo pip3 install -r requirements.txt

echo "--- Web Server Config ---"
sudo cp -r /opt/trackdirect/www/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 775 /var/www/html/public/symbols
