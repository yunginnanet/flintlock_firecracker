#!/usr/bin/env bash

function run_flintlock() {
	sudo screen -dmLS flintlockd "$BINDIR/flintlockd" run \
		--containerd-socket="/run/$CTRD/containerd.sock" \
		--parent-iface="${NET_DEVICE}" \
		--insecure
	if ! sudo ps aux | grep -v grep | grep -i flintlockd 2>/dev/null; then
		echo "waiting..."
		sleep 5
		sudo ps aux | grep -v grep | grep -i flintlockd 2>/dev/null || return 1
	fi
	return 0
}

set -e
_installed=false

echo -n -e "\nchecking for existing flintlockd in path... "
if flintlockd version >/dev/null; then
	echo -e -n "✅\n\n"
	_installed=true
fi

if $_installed; then
	while :; do
		read -r -p "Rebuild and run flintlock? (y/n): " yn
		case $yn in
		[Yy]*) break ;;
		[Nn]*) exit 1 ;;
		*) echo "its a yes or no question, g." ;;
		esac
	done
fi

echo "building flintlockd..."
source .env
_pwd="$(pwd)"
rm -vrf "$_pwd/tmp" 2>/dev/null || true
mkdir -p "$_pwd/tmp"
cd "$_pwd/tmp"
git clone --recurse-submodules https://github.com/weaveworks-liquidmetal/flintlock
cd "$_pwd/tmp/flintlock"
go mod tidy -v
make build
install -b --mode +x --preserve-timestamps "./bin/flintlockd" "$BINDIR/flintlockd"
cd "$_pwd"
rm -vrf "$_pwd/tmp" 2>/dev/null || true

run_flintlock && echo -e "\n\n\e[0;32mflintlockd is running!\e[0m\n\n"
