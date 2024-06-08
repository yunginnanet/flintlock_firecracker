#!/usr/bin/env bash
set -e
echo "setting tap interface up..."
source .env
sudo ip tuntap add ${TAPNAME} mode tap
sudo ip link set ${TAPNAME} master ${BRIDGE} up
