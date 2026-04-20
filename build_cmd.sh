#!/bin/bash

set -xe

path=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
image=registry.opensuse.org/home/dcassany/elemental/demo/containers/elemental3:latest
imagefile=singlenode-image
vm=singlenode-dumbledore

export LIBVIRT_DEFAULT_URI='qemu:///system'

virsh destroy "${vm}" || true
virsh undefine "${vm}" --nvram || true

rm -rv "${path}/${imagefile}".* || true

podman run --rm -it -v "${path}:/host" -v "${DOCKER_HOST##unix://}:/var/run/docker.sock" "${image}" \
  --debug customize \
  --config-dir /host/single_node \
  --type raw \
  --local \
  --output "/host/${imagefile}.raw"

[ -e "${path}/${imagefile}.raw" ] || exit 1

qemu-img convert -f raw -O qcow2 "${path}/${imagefile}.raw" "${path}/${imagefile}.qcow2"
qemu-img resize "${path}/${imagefile}.qcow2" 16G

virt-install \
  --name "${vm}" \
  --memory 4096 \
  --vcpus 2 \
  --disk "path=${path}/${imagefile}.qcow2,bus=virtio" \
  --import \
  --os-variant opensusetumbleweed \
  --boot uefi \
  --network network=default,mac=FE:C4:05:42:8B:05 \
  --graphics spice,listen=0.0.0.0 \
  --video qxl \
  --channel spicevmc
