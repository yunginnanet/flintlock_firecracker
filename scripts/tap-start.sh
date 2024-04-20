source .env
sudo ip tuntap add ${TAPNAME} mode tap
sudo ip link set ${TAPNAME} master ${BRIDGE} up
