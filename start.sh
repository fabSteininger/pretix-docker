#!/bin/sh

# Check if the user provided a variable
export INSTANCE="my_instance"
export DOMAIN="my_domain"
# Email for Let's Encrypt certificate
EMAIL="your@email.com"
# Config for SMTP Service
export MAIL="FROM_MAIL"
export HOST="MAIL_SERVER"
export USER="USERNAME"
export MAIL_PASSWORD="FOOBAR"
export PORT="587"
export TLS="off"
export SSL="off"



# Generate Postgres Password
export PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%&()' | fold -w 16 | head -n 1)
echo DB PASSWORD = $PASSWORD

# Replace PASSWORD in docker-compose.yml 
envsubst '${PASSWORD}' < docker-compose.template.yml > docker-compose.yml

# Start docker service with certbot
docker compose up -d certbot

# Open shell to certbot and create the directory
sudo docker exec -it certbot sh -c "mkdir -p /etc/letsencrypt/live/$DOMAIN"

# Create self-signed certificate with OpenSSL
sudo docker exec -it certbot sh -c "
    openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
    -keyout /etc/letsencrypt/live/$DOMAIN/privkey.pem \
    -out /etc/letsencrypt/live/$DOMAIN/fullchain.pem \
    -subj '/CN=localhost'"

echo "Directory created: /etc/letsencrypt/live/$DOMAIN"

# Replace environment variables in the Nginx template
envsubst '${DOMAIN}' < docker/pretix/nginx/nginx.template.conf > docker/pretix/nginx/nginx.conf
# Setup pretix
envsubst '${PASSWORD} ${DOMAIN} ${INSTANCE} ${MAIL} ${HOST} ${USER} ${PORT} ${MAIL_PASSWORD} ${TLS} ${SSL}' < docker/pretix/pretix.template.cfg > docker/pretix/pretix.cfg


echo "Added the $DOMAIN to the nginx.conf"
docker compose down

echo "Add now your Public IP to your Domain Records and wait a bit: $(curl -s https://api64.ipify.org)"

# Ask for confirmation
read -p "Press 'y' to confirm and move on: " confirm
if [ "$confirm" = "y" ]; then
    echo "Starting docker container and setting up SSL certificate"
    docker compose up -d --build --force-recreate
    echo "Sleep for 2 minutes"
    sleep 120
    rm -r certbot/conf/live/$DOMAIN
    docker compose run --rm certbot certonly --webroot -w /var/www/certbot -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email
    # Define the cron job
    CRON_JOB="0 3 * * * docker compose run --rm certbot renew"
    
    # Check if the cron job already exists, if not, add it
    (crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    # Restart the ngnix container to apply signed certificate
    sleep 10
    sudo docker compose restart
    echo "Setup finished - Check now on your $DOMAIN"
else
    echo "You did not press 'y'. Exiting."
fi

