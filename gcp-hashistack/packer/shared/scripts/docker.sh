#!/bin/bash

set -e
# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

SCRIPT=`basename "$0"`

echo "[INFO] [${SCRIPT}] Setup docker engine"

distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
sudo apt-get install -y apt-transport-https ca-certificates gnupg2 
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/${distro} $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

echo "[INFO] [${SCRIPT}] Success setup docker engine"