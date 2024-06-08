#!/usr/bin/env bash
set -e
echo "getting flintlock..."
source .env
mkdir -p tmp || true
cd tmp
rm -vrf flintlock
git clone --recurse-submodules https://github.com/weaveworks-liquidmetal/flintlock
cd flintlock
go mod tidy -v
make build
sudo screen -dmLS flintlockd ./bin/flintlockd run \
	--containerd-socket="/run/$CTRD/containerd.sock" \
	--parent-iface="${NET_DEVICE}" \
	--insecure
if ! sudo ps aux | grep -i flintlockd >/dev/null; then
	echo "waiting..."
	sleep 5
	sudo ps aux | grep -i flintlockd
fi
