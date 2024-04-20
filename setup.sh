#!/usr/bin/env bash
set -e
source .env
./scripts/get-firecracker.sh
./scripts/net-cleanup.sh 2>/dev/null || true
./scripts/net-start.sh
./scripts/tap-start.sh
sudo virsh net-dhcp-leases $LVNET
./scripts/start-containerd.sh
