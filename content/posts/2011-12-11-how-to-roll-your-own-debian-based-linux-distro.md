---
title: How to roll your own Debian based Linux distro
author: Mikael Ståldal
type: post
date: 2011-12-11T22:10:30+00:00
url: /2011/12/11/how-to-roll-your-own-debian-based-linux-distro/
category:
  - Linux

---
### Goal

To build a minimal Debian based Linux system with a fully functional bash shell, TCP/IP networking with DHCP client and apt setup to be able to install any package from the Debian repositories. The resulting system will use about 157 MB disk space and consume less than 10 MB RAM.

_This is now implemented in [Bachata Linux][1]._

### Prerequisites

A Debian based Linux system to work from (e.g. Ubuntu desktop) with the `debootstrap` and `extlinux` packages installed. Some virtualization environment is highly recommended for testing, such as KVM/QEMU.

### Install system

This will install the system on a disk mounted at `mnt`. Choose a hostname for the instance to create, substitute it for ${HOSTNAME}. Substitute the URL to your nearest [Debian mirror][2] for ${MIRROR}.

  1. `sudo debootstrap --variant=minbase --include=localepurge,netbase,ifupdown,net-tools,isc-dhcp-client,linux-base,linux-image-2.6-686,linux-image-2.6.32-5-686 squeeze mnt ${MIRROR}` 
  2. sudo rm mnt/etc/udev/rules.d/70-persistent-net.rules 
  3. sudo rm mnt/var/cache/apt/archives/* 
  4. sudo rm mnt/var/cache/apt/*.bin 
  5. sudo rm mnt/var/lib/apt/lists/* 
  6. sudo rm mnt/var/log/dpkg.log* 
  7. sudo rm mnt/var/log/apt/* 
  8. sudo mkdir mnt/boot/extlinux 
  9. `sudo extlinux --install mnt/boot/extlinux` 
 10. sudoedit mnt/boot/extlinux/syslinux.cfg 
```
default linux 
    label linux
    kernel /boot/vmlinuz-2.6.32-5-686
    append initrd=/boot/initrd.img-2.6.32-5-686 root=UUID=${UUID} ro quiet
```
    
    _Only for KVM/QEMU:_ add `console=ttyS0` to the &#8220;append&#8221; line

 11. sudoedit mnt/etc/inittab  
    _For KVM/QEMU:_ uncomment getty ttyS0 and comment out getty tty[1-6]  
    _For others:_ comment out getty tty[2-6] 
 12. sudoedit mnt/etc/passwd &#8211; blank password for root 
 13. sudoedit mnt/etc/network/interfaces 
```
auto lo
iface lo inet loopback
allow-hotplug eth0
iface eth0 inet dhcp

```

 14. sudoedit mnt/etc/fstab 
```
# /etc/fstab: static file system information.
#
# Use 'blkid -o value -s UUID' to print the universally unique identifier
# for a device; this may be used with UUID= as a more robust way to name
# devices that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>             <dump>  <pass>
proc            /proc           proc    nodev,noexec,nosuid   0       0
UUID=${UUID}        /               ext2    errors=remount-ro     0       1

```

 15. sudoedit mnt/etc/hostname 
```
${HOSTNAME}

```

 16. sudoedit mnt/etc/locale.nopurge 
```
MANDELETE

DONTBOTHERNEWLOCALE

SHOWFREEDSPACE

#QUICKNDIRTYCALC

#VERBOSE

en

```

 17. sudoedit mnt/etc/apt/sources.list 
```
deb ${MIRROR} squeeze main
deb-src ${MIRROR} squeeze main

deb http://security.debian.org/ squeeze/updates main
deb-src http://security.debian.org/ squeeze/updates main

# squeeze-updates, previously known as 'volatile'
deb ${MIRROR} squeeze-updates main
deb-src ${MIRROR} squeeze-updates main

```

 18. sudoedit mnt/etc/apt/apt.conf.d/02nocache 
```
Dir::Cache {
  srcpkgcache "";
  pkgcache "";
}

```

 19. sudoedit mnt/etc/apt/apt.conf.d/02compress-indexes 
```
Acquire::GzipIndexes "true";
Acquire::CompressionTypes::Order:: "gz";

```

 20. sudo chroot mnt localepurge 
 21. sudo chroot mnt apt-get update 
 22. sudo chroot mnt passwd root 

### Install on a physical disk

  1. Create a bootable partition of at least 288 MB with system code 83 &#8220;Linux&#8221; using `fdisk`
  2. sudo mke2fs -L ${HOSTNAME} -t ext2 /dev/_xxxx_ 
  3. sudo UUID=\`blkid -o value -s UUID /dev/_xxxx_\` 
  4. mkdir mnt 
  5. sudo mount /dev/_xxxx_ mnt 
  6. _Install system as above_ 
  7. sudo umount mnt 

### Install in KVM/QEMU

  1. dd if=/dev/zero of=${HOSTNAME}.img bs=1024 count=288K 
  2. mke2fs -L ${HOSTNAME} -t ext2 ${HOSTNAME}.img 
  3. UUID=\`blkid -o value -s UUID ${HOSTNAME}.img\` 
  4. mkdir mnt 
  5. sudo mount ${HOSTNAME}.img mnt 
  6. _Install system as above_ 
  7. sudo umount mnt 
  8. `virt-install --connect qemu:///system -n ${HOSTNAME} -r 256 --os-type linux --os-variant debiansqueeze --import --disk path=${HOSTNAME}.img --network=network:default --graphics none --virt-type kvm` 

Use `--virt-type qemu` if your CPU doesn&#8217;t support virtualization.

Then you can start it with `virsh start ${HOSTNAME}` and connect to it with `virsh console ${HOSTNAME}`

For some reason, doing `reboot` from inside the guest doesn&#8217;t seem to work properly. `virsh reboot` and `virsh shutdown` doesn&#8217;t work either (you might get that to work by installing some ACPI stuff in the guest). Use `halt` from inside the guest to have a clean shutdown, and then restart it with `virsh start`.

### Install in VirtualBox 4.1

First create a virtual machine in VirtualBox with an empty VDI disk ${VDI_FILE} of least 288 MB.

Install VDI mounting tool according to [this][3] description.

  1. mkdir vdi-mount
  2. vdfuse-v82a -f ${VDI_FILE} vdi-mount
  3. mke2fs -L ${HOSTNAME} -t ext2 vdi-mount/EntireDisk
  4. mkdir mnt
  5. sudo mount vdi-mount/EntireDisk mnt
  6. _Install system as above_
  7. sudo umount mnt
  8. fusermount -u vdi-mount

Then start the virtual machine in VirtualBox.

### Install in other virtualization environments

_Please tell me how!_

 [1]: http://www.bachatalinux.net/
 [2]: http://www.debian.org/mirror/
 [3]: http://jorgenmodin.net/index_html/archive/2011/12/13/mount-a-virtualbox-vdi-file-on-ubuntu-and-debian