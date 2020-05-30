#!/bin/bash

#qemu -m 2048 -cpu host -nographic -snapshot \
#	-drive if=virtio,file=fedora-coreos-qemu.qcow2 \
#	-fw_cfg name=opt/com.coreos/config,file=example.ign

qemu-system-x86_64 \
  -accel kvm \
  -smp cpus=2 \
  -m 2048 \
  -cpu host \
  -nographic \
  -nic bridge,model=virtio-net-pci,br=coreosbr,mac=00:CE:30:74:A1:89 \
  -snapshot \
  -drive if=virtio,file=blob/fedora-coreos-qemu.qcow2.patched \
  -fw_cfg name=opt/com.coreos/config,file=example.ign

  #-drive if=virtio,file=images.img \
  #-drive if=virtio,file=blob/images.squashfs \
