#!/usr/bin/env bash
set -e
source .env
echo "setting up virtd network: $LVNET"
rm -v "assets/user/$LVNET-net.xml" 2>/dev/null || true
sed "s|flbr0|$BRIDGE|g" assets/flintlock-net.xml |
	sed "s|flintlock|$LVNET|g" >>"assets/user/$LVNET-net.xml"
sudo virsh net-define "assets/user/$LVNET-net.xml"
sudo virsh net-start "$LVNET"
