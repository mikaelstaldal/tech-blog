---
title: 'Ubuntu in Ubuntu'
slug: ubuntu-in-ubuntu
author: 'Mikael Ståldal'
type: post
date: 2026-02-08T20:00:00+01:00
year: 2026
month: 2026/02
day: 2026/02/08
category:
  - Linux
  - Ubuntu
  - security

---

I want an easy way to run one or more ephermal Linux VMs in Ubuntu desktop, including the possibility to mount host directories into them in an efficient fashion.
Those VMs should have the same CPU architecture and hardware features as the host, no need to emulate some foreign CPU or special hardware, and no GUI in the VMs.
The intended use case is sandboxing and isolation for security and reproducability reason. To be used as a cheaper alternative to a remote cloud instance. 
Or as a more secure alternative to Docker/Podman containers, with possibility to install Docker or Podman in the VM, and run containers there without affecting the 
host or other VMs (it's not feasible to nest containers in a secure manner without a proper VM).

You can do this with [libvirt (virt-install and virsh)](https://www.staldal.nu/tech/2024/09/02/linux-in-linux-with-kvm/), but that can be quite complicated and I want an easier way for 
this limited use case.

I had a look at [UVtool](https://documentation.ubuntu.com/server/how-to/virtualisation/cloud-image-vms-with-uvtool/) which is an abstraction layer on top of libvirt. It works, but
it does not support mounting directories into the VM. It is also quite old and apparently not developed any longer. It is also not ideal to have an abstraction layer on top of 
another abstraction layer (libvirt).

I also had a look at [Multipass](https://documentation.ubuntu.com/server/how-to/virtualisation/multipass/) which is newer, actively maintained, and does support mounting.
However, it uses an inefficient method of mounting (and does not support mounting read-only). I would like mounting with [Virtiofs](https://virtio-fs.gitlab.io/). Multipass is
also overly complicated in the sense that it is multi-platform, supports multiple OS:es and virtualization technologies. I would perfer something simpler and more focused, 
only for Linux and KVM/QEMU.

Something like UVtool but with support for mounting with Virtiofs would be nice. So I developed [virter](https://github.com/mikaelstaldal/virter), 
which uses KVM/QEMU directly without libvirt. It has been tested with Ubuntu Desktop 24.04 on AMD64 CPU, but should work on any Linux system with KVM, QEMU and Virtiofs.
