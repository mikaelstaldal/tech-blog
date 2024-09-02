---
title: 'Linux in Linux with KVM'
slug: linux-in-linux-with-kvm
author: 'Mikael Ståldal'
type: post
date: 2024-09-02T20:18:49+02:00
year: 2024
month: 2024/09
day: 2024/09/02
category:
  - Linux
  - Ubuntu
  - security

---
You can do quite a lot with Docker, but sometimes you want greater capabilities or increased security, then a proper 
virtual machine with KVM is a good alternative. An example is when you want to run Docker containers in the VM, it's 
not easy to nest Docker without forgoing all security.

Just like [Alpine Linux](https://www.alpinelinux.org/) is 
[suitable as a base for Docker images](http://localhost:1313/tech/2023/04/20/alpine-rather-than-distroless/), 
it is also a good option as a guest in a virtual machine. 

Here is how you can run Alpine Linux 3.20 in Ubuntu 24.04.

Install KVM with friends:
```shell
apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virtiofsd
```

Create a VM called `dev-vm` running Alpine Linux and share directory `~/src` with it:
```shell
wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-virt-3.20.2-x86_64.iso
virt-install --name dev-vm \
    --disk size=4 \
    --location $HOME/Downloads/alpine-virt-3.20.2-x86_64.iso,kernel=boot/vmlinuz-virt,initrd=boot/initramfs-virt \
    --extra-args console=ttyS0 \
    --osinfo alpinelinux3.19 \
    --graphics none \
    --console pty,target_type=serial \
    --filesystem=$HOME/src,src,driver.type=virtiofs \
    --memorybacking=source.type=memfd,access.mode=shared
```

Setup Alpine in the newly created VM:
```shell
setup-alpine
reboot
```

Mount the shared directory (and make sure it mounts automatically on boot):
```shell
mkdir /src
echo "src /src virtiofs defaults 0 0" >>/etc/fstab
mount /src
```

Then you can shut down the VM from inside with `poweroff`, and reboot it from inside with `reboot`.

Start it from outside with `virsh start dev-vm`, and (re)connect to it with `virsh console dev-vm`, 
no need to install SSH server in the VM. The VM image ends up in `~/.local/share/libvirt/images`.

I wish I could script/automate the initialization of the VM more. Alpine docs 
[suggests using cloud-init](https://wiki.alpinelinux.org/wiki/KVM#Provision_an_Alpine_Linux_vm_with_virt-install), 
but I could not get that to work. Anyway, this works, and you only have to do the initialization once since the 
VM image is stored on disk and can be restarted multiple times.
