#!/bin/bash

set -e
# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

SCRIPT=`basename "$0"`

echo "[INFO] [${SCRIPT}] Setup java openjdk-8"

# Java
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update 
sudo apt-get install -y openjdk-8-jdk
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

echo "[INFO] [${SCRIPT}] Success setup java openjdk-8"
