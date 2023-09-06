#!/bin/bash

set -e
# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

SCRIPT=`basename "$0"`
CNI_VERSION=v1.3.0
BRIDGE_NETWORK_TARGET=/etc/sysctl.d
CONFIG_FILE=bridge.conf

echo "[INFO] [${SCRIPT}] Install CNI Plugins $CNI_VERSION"

curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-$CNI_VERSION.tgz && \
  sudo mkdir -p /opt/cni/bin && \
  sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz

echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-arptables && \
  echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-ip6tables && \
  echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

sudo mkdir -p $BRIDGE_NETWORK_TARGET

sudo cat <<EOF > $CONFIG_FILE
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo cp $CONFIG_FILE $BRIDGE_NETWORK_TARGET/$CONFIG_FILE

sudo systemctl restart systemd-resolved

echo "[INFO] [${SCRIPT}] Success install CNI Plugins $CNI_VERSION"