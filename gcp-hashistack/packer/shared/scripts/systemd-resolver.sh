#!/bin/bash

set -e
# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

SCRIPT=`basename "$0"`

echo "[INFO] [${SCRIPT}] Setup SystemD Resolver to use Consul DNS"

DNS_TMP=consul.conf
DNS_CONSUL_CONF_DIR=/etc/systemd/resolved.conf.d
DNS_CONSUL_CONF_FILE=$DNS_CONSUL_TARGET/$DNS_TMP

sudo mkdir -p $DNS_CONSUL_CONF_DIR

sudo cat <<EOF > ./$DNS_TMP
[Resolve]
DNS=127.0.0.1:8600
DNSSEC=false
Domains=~consul
EOF

sudo cp ./$DNS_TMP $DNS_CONSUL_CONF_FILE

sudo systemctl restart systemd-resolved

echo "[INFO] [${SCRIPT}] Success setup SystemD Resolver Consul DNS"
