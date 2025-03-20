# Pretix Docker-Compose setup
The repository includes a [Pretix](https://pretix.eu/about/de/) docker-compose configuration.

Used under Debian 12

## Usage

Install Docker
https://docs.docker.com/engine/install/debian/

Get all files
```bash
git clone https://github.com/fabSteininger/pretix-docker.git
cd pretix-docker
```

Edit the variables in the script e.g. with nano start.sh
```yaml
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
```

start the script and follow the instructions
```bash
chmod +x start.sh
sudo bash start.sh
```

## The docker compose setup is based on
https://github.com/ZPascal/pretix-docker-compose/tree/main
