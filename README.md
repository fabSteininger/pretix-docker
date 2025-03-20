# Pretix Docker-Compose setup
The repository includes a [Pretix](https://pretix.eu/about/de/) docker-compose configuration.

Used under Debian 12

## Usage

Install Docker
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Start everything with the script start.sh edit the variables before, the script then automatically generates a certificate via certbot for the given domain.
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

## The docker compose setup is based on
https://github.com/ZPascal/pretix-docker-compose/tree/main
