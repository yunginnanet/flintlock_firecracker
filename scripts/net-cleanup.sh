#!/usr/bin/env bash
source .env
echo "cleaning up any existing virtd network named $LVNET"
sudo virsh net-destroy --network "$LVNET" || true
sudo virsh net-undefine --network "$LVNET" || true
sudo ip link delete $BRIDGE || true # should have no spaces
sudo ip link delete $TAPNAME || true # should have no spaces
