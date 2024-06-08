#!/usr/bin/env bash
if ! sudo true; then
	echo "root rights are required."
	exit 1
fi

if sudo ps aux | grep -v grep | grep -i flintlockd 2>/dev/null; then
	echo -e "\n\nflintlockd is already running.\n\nif you'd like to rebuild it and start it again, please kill the existing instance of flintlockd.\n\n"
	exit 1
fi

set -e

source .env || cp assets/env-template ./.env && source .env
./scripts/get-firecracker.sh
./scripts/net-cleanup.sh 2>/dev/null || true
./scripts/net-start.sh
./scripts/tap-start.sh
sudo virsh net-dhcp-leases "$LVNET"
./scripts/start-containerd.sh
./scripts/get-flintlock.sh
