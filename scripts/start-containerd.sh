sudo mkdir -p /var/lib/containerd-dev/snapshotter/devmapper 2>/dev/null
sudo mkdir -p /run/containerd-dev/ 2>/dev/null
sudo containerd --config containerd.toml&
sudo ctr \
    --address=/run/containerd-dev/containerd.sock \
    --namespace=flintlock \
    content ls
