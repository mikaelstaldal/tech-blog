---
title: How to roll your own bootable Linux CD-ROM
author: Mikael Ståldal
type: post
date: 2012-01-04T14:32:44+00:00
url: /2012/01/04/how-to-roll-your-own-bootable-linux-cd-rom/
category:
  - Linux

---
When booting a regular Linux system, it just mounts some partition with a nice file system (such as ext4) on your HDD on / read/write and there you go.

When booting from a CD-ROM, it&#8217;s not that simple. The CD-ROM file system, ISO 9660, does not support the file names and attributes that a Linux system normally needs. And the CD-ROM is read only.

There are ways to work around these issues. You can use [the Rock Ridge extension][1] to ISO 9660 to get the file names and attributes needed. And the read only issue can be handled either as I have [described in an earlier post][2], or by using [unionfs][3].

There is also a different approach which I will describe here. Have an image file of the root file system on the CD which you mount in RAM. This will bypass the restrictions of ISO 9660 since you can use any file system in the image, and it can be read/write after being read into RAM. The obvious disadvantage is that this will consume RAM proportional to the size of the root file system, which can be a problem since you will not have any swap space available. But in several use cases, the size of the root file system can be kept small enough for this to work.

The easiest, and probably best, way to do this is to simply use the [initramfs][4] mechanism built into the Linux kernel.

In the initramfs, the Linux kernel will start executing `/init` as the first process, and this process is not expected to exit. This `/init` can be (and usually is) a shell script. In a regular root file system, `/sbin/init` will be executed first. So you can convert a regular root file system into an initramfs by adding an `/init` like this (don&#8217;t forget to make it executable):

```
#!/bin/sh

exec /sbin/init $@

```

Then you need to package it as a gzipped cpio archive with these slightly awkward commands (`${ROOT_FS}` is where you have prepared the root file system, `${ISO_FS}` is where you are preparing the file system for the CD-ROM, don&#8217;t forget to create the directory `${ISO_FS}/isolinux` first):

```
(cd ${ROOT_FS} && find . -type l -printf '%p %Y\n' | sed -n 's/ [LN]$//p' | xargs -rL1 rm -f)
(cd ${ROOT_FS} && find . | cpio --quiet -o -H newc | gzip -9 >${ISO_FS}/isolinux/initrd.img)

```

Then put this initramfs image along with the kernel image and pass it to the bootloader. Given that you use isolinux as bootloader, put the kernel image in `${ISO_FS}/isolinux/vmlinuz`, copy `isolinux.bin` to `${ISO_FS}/isolinux/` and create a config file `${ISO_FS}/isolinux/isolinux.cfg`:

```
default linux
label linux
    kernel vmlinuz
    append initrd=initrd.img quiet

```

Finally build an CD-ROM ISO image with this command:

```
genisoimage -b isolinux/isolinux.bin -c isolinux/boot.cat \
 -no-emul-boot -boot-load-size 4 -boot-info-table \
 -l -input-charset default -V MyLinuxBoot -A "My Linux Boot" \ 
 -o ${ISO_IMAGE} ${ISO_FS}

```

Then you can burn the ISO image on a CD-ROM, or use the image directly to test it in a virtual machine.

You can reduce the size of the root file system by placing some large auxiliary files (such as the files to install if you are building an installer) outside, directly on the CD-ROM. Then you need to mount the CD-ROM after boot, which can be a bit tricky. Given that you know that a file `install.cgz` should be on the CD-ROM, you can do like this to mount the CD-ROM on `/media`:

```
mount_cdrom() {
    for CD in /dev/cdrom /dev/cdrom[0-9] /dev/sr[0-9]; do
        if [ -b ${CD} ] ; then 
            if mount -t iso9660 -o ro ${CD} /media 2>/dev/null ; then
                if [ -f ${1}/install.cgz ] ; then
                    return
                else
                    umount /media
                fi
            fi
        fi
    done
    echo "Failed to mount CD!"
}

```

This is inspired from [this article][5]. However, that article uses the older and less efficient initrd instead of initramfs. It also mounts the root file system in a two-step bootstrap process which seems redundant to me. So I have made it simpler and more efficient. The procedure with boot menus and different run levels described in the section <cite>Customizing and Adding Scripts</cite> can be useful though, I recommend reading that section if you need some kind of menu.

 [1]: http://en.wikipedia.org/wiki/Rock_ridge
 [2]: http://www.staldal.nu/tech/2009/11/15/linux-with-mounted-read-only-2-0/
 [3]: http://en.wikipedia.org/wiki/Unionfs
 [4]: http://en.wikipedia.org/wiki/Initramfs
 [5]: http://www.phenix.bnl.gov/~purschke/RescueCD/