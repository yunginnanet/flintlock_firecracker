# flintlock_firecracker

helper scripts that build [firecracker](https://firecracker-microvm.github.io/), [flintlock](https://github.com/weaveworks-liquidmetal/flintlock), and set up containerd along with the libvirtd networking as per flintlock docs.

essentially just automates everything they outline in the [flintlock docs](https://weaveworks-liquidmetal.github.io/flintlock/docs/category/getting-started/).

please read every script in this repo if you're going to use this, there's a lot of sudo fuckery in there. with that said, the mechanisms at play here should be fairly tidy and very robust.

### usage

in theory, just run `./setup.sh`

in reality, there's a reasonable chance that this is only that seamless on my machine. ymmv :^)

### dipswitches

`.env` is the config, if `.env` is not present it copies the template from `assets/env-template`

  - `BRIDGE`
    flintlock/libvirtd bridge interface name
  - `TAPNAME`
    flintlock/libvirtd TAP interface name
  - `LVNET`
    libvirtd network name
  - `BINDIR`
    location in path where firecracker and flintlock bins will be installed
  - `CTRD`
    containerd namespace name
  - `NET_DEVICE`
    bridge target for VM networking
