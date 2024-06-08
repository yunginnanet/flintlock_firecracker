#!/usr/bin/env bash
set -e
source .env
echo "starting containerd..."
sudo mkdir -p "/var/lib/$CTRD/snapshotter/devmapper" 2>/dev/null || true
sudo mkdir -p "/run/$CTRD/" 2>/dev/null || true
rm -vf "assets/user/$CTRD.toml" 2>/dev/null || true
sed "s|containerd-dev|$CTRD|g" assets/containerd.toml |
	sed "s|flintlock-dev|$LVNET-pool|g" |
	tee "assets/user/$CTRD.toml"
ls "assets/user/$CTRD.toml"
_pwd="$(pwd)"
_ctrd="$(which containerd)"
sudo screen -dmLS "$CTRD" "$_ctrd" --config "$_pwd/assets/user/$CTRD.toml"
sleep 1
if ! sudo screen -ls | grep -i "$CTRD"; then
	echo "containerd didn't spawn in screen session"
	false
fi
if ! sudo ps aux | grep -v grep | grep -i containerd >/dev/null; then
	echo "waiting..."
	sleep 5
	sudo ps aux | grep -v grep | grep -i containerd
fi
if ! sudo ctr --address="/run/$CTRD/containerd.sock" --namespace="$LVNET" content ls; then
	echo -e '\n\n\n\n'
	echo -e -n "failed to connect to ${LVNET} namespace with containerd\ndropping into the screen session in 5 seconds"
	for i in {1,1,1,1,1}; do
		sleep "$i"
		echo -n "."
	done
	sudo screen -dr "$CTRD"
fi
sudo screen -X -S "$CTRD" quit
