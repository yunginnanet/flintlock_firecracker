source .env
sudo virsh net-stop --network $LVNET
sudo virsh net-destroy --network $LVNET
sudo virsh net-undefine --network $LVNET
sudo ip link delete $BRIDGE
sudo ip link delete $TAPNAME
