#!/usr/bin/env bash

echo -n "checking for firecracker installation with macvtap enabled..."

_fcv=$(firecracker --version 2>/dev/null)

if echo -n "$_fcv" | grep -i macvtap >/dev/null; then echo "✅"; exit 0; else echo "❌"; fi

echo "building firecracker with macvtap..."

set -e
source .env

if grep -i Debian /etc/issue; then
	sudo apt-get -y install musl musl-dev musl-tools
	sudo ln -s /usr/include/linux /usr/include/x86_64-linux-musl/ 2>/dev/null || true
	sudo ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/ 2>/dev/null || true
	sudo ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/ 2>/dev/null || true
fi

rm -vrf tmp
mkdir -p tmp
cd tmp
git clone https://github.com/weaveworks/firecracker.git
cd firecracker
git fetch origin feature/macvtap
git checkout -b feature/macvtap origin/feature/macvtap
rm Cargo.lock
rustup toolchain install stable-musl
rustup target add x86_64-unknown-linux-musl
cargo check
_res="$( ( ./tools/release.sh; ) | tail -n 1)"
echo "$_res" | grep -i 'binaries placed'
_dir="$(echo "$_res" | awk '{print $NF}')"
install -b --mode +x --preserve-timestamps "$_dir/firecracker" "$FCDIR/firecracker"
_fcv="$(firecracker --version | head -n 1);"
if ! echo "$_fcv" | grep -i macvtap; then echo "wrong version firecracker, not macvtap"; false; fi
cd ..
rm -vrf tmp
echo -e "\n\n\e[0;32msuccessfully installed $_fcv\e[0m\n\n"
