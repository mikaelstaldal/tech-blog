---
title: Linux with / mounted read-only
author: Mikael Ståldal
type: post
date: 2008-07-26T10:41:43+00:00
url: /2008/07/26/linux-with-mounted-read-only/
categories:
  - Linux

---
_(This post has been edited since it was first published.)_

I wondered why you usually mount / (the root file system) read-write in Linux and decided to do some experiments to find out if it is possible to have it mounted read-only. 

So why do you want to do that? Perhaps you have the root file system on a read-only media, such as CD-ROM. Or on a writable media which can only handle a limited number of writes, such as a CD-RW or flash disk. It would also increase security since it will be more difficult (though not impossible) for some [malware][1] to infect your system.

I found out that it is possible to mount / read-only, but only after some tweaking. Here is how I did it in [Ubuntu][2] 8.04 (hardy) desktop.

The first obvious step is to change the mount options to &#8220;ro&#8221; for / in `/etc/fstab` and reboot. But the tweaking has to be done first, so don&#8217;t reboot yet!

There are some locations in the file system which has to be writeable, the solution is to mount them as `tmpfs`. After some experiments, I found out that I had to mount the following locations as `tmpfs` (assuming that `/dev` is already mounted in an appropriate way):

  * `/tmp`
  * `/media`
  * `/var/run`
  * `/var/lock`
  * `/var/tmp`
  * `/var/crash`
  * `/var/log`
  * `/var/lib/xkb`
  * `/var/lib/gdm`
  * `/var/lib/dhcp3` (only if you use DHCP client)
  * `/var/lib/nfs` (only if you use NFS client)
  * `/var/spool/cups`

Ubuntu mounts `/var/run` and `/var/lock` as `tmpfs` by default, and this is done in `/etc/init.d/mountkernfs.sh` and `/etc/init.d/mtab.sh`. 

Add this to `/etc/init.d/mountkernfs.sh` after the mounting of `/var/lock`:

```
domount tmpfs "" /var/tmp -omode=1777,nodev,noexec,nosuid
domount tmpfs "" /var/crash -omode=0755,nodev,noexec,nosuid

domount tmpfs "" /var/spool/cups -omode=0710,nodev,noexec,nosuid
chgrp lp /var/spool/cups
mkdir /var/spool/cups/tmp
chmod 1770 /var/spool/cups/tmp
chgrp lp /var/spool/cups/tmp

domount tmpfs "" /var/log -omode=0755,nodev,noexec,nosuid
mkdir /var/log/apparmor
mkdir /var/log/apt
mkdir /var/log/cups
mkdir /var/log/dist-upgrade
mkdir /var/log/fsck
mkdir /var/log/gdm
mkdir /var/log/news
mkdir /var/log/samba
mkdir /var/log/unattended-upgrades

domount tmpfs "" /var/lib/dhcp3 -omode=0755,nodev,noexec,nosuid

domount tmpfs "" /var/lib/xkb -omode=0755,nodev,noexec,nosuid

domount tmpfs "" /var/lib/gdm -omode=0755,nodev,noexec,nosuid
mkdir /var/lib/gdm/.fontconfig

domount tmpfs "" /var/lib/nfs -omode=0755,nodev,noexec,nosuid
mkdir /var/lib/nfs/sm
mkdir /var/lib/nfs/sm.bak
mkdir /var/lib/nfs/rpc_pipefs

domount tmpfs "" /tmp -omode=1777,nodev,exec,nosuid
touch /tmp/resolv.conf
touch /tmp/adjtime

# this is necessary to avoid that the above files are removed later in the boot process
touch /tmp/.clean

domount tmpfs "" /media -omode=0755,nodev,noexec,nosuid
# The following lines are not necessary in 9.04, perhaps not in 8.10 either
mkdir /media/cdrom0
ln -s /media/cdrom0 /media/cdrom
mkdir /media/floppy0
ln -s /media/floppy0 /media/floppy
mkdir /media/usbdisk

```

And add this to `/etc/init.d/mtab.sh` after the handling of `/var/lock`:

```
domtab tmpfs /var/log "varlog" -omode=0755,nodev,noexec,nosuid
domtab tmpfs /var/tmp "vartmp" -omode=1777,nodev,noexec,nosuid
domtab tmpfs /var/crash "varcrash" -omode=0755,nodev,noexec,nosuid
domtab tmpfs /var/spool/cups "varspoolcups" -omode=0710,nodev,noexec,nosuid
domtab tmpfs /var/lib/dhcp3 "varlibdhcp3" -omode=0755,nodev,noexec,nosuid
domtab tmpfs /var/lib/xkb "varlibxkb" -omode=0755,nodev,noexec,nosuid
domtab tmpfs /var/lib/gdm "varlibgdm" -omode=0755,nodev,noexec,nosuid
domtab tmpfs /var/lib/nfs "varlibnfs" -omode=0755,nodev,noexec,nosuid

domtab tmpfs /tmp "tmp" -omode=1777,nodev,exec,nosuid
domtab tmpfs /media "media" -omode=0755,nodev,noexec,nosuid

```

(I am not really sure what the actual purpose of `/etc/init.d/mtab.sh` is, perhaps it&#8217;s not necessary to modify it.)

There are some files in `/etc` which have to be writeable:

  * `/etc/mtab`
  * `/etc/adjtime`
  * `/etc/resolv.conf` (only if you use DHCP client and let it set DNS configuration)

I handle `/etc/mtab` by symlink it to `/proc/mounts`, that has some minor side-effects but I can live with it. I handle `/etc/adjtime` and `/etc/resolv.conf` by symlinking them to `/tmp`. In order for this to work, you have to patch the DHCP client (dhcp3-client) accodring to [this bug report][3].

You also have to mount `/home` read-write somewhere, and I would not recommend using `tmpfs`. You can use a separate hard disk partition or NFS.

Finally it might be a good idea to set a password for the root account, this enables you to switch to a virtual console (`Ctrl`&#8211;`Alt`&#8211;`F1`) and login as root if something goes wrong.

If you then do want to change anything, such as edit a file in `/etc` or install or upgrade a package, you can just remount / as read-write temporary (assuming that the media actually is writeable):  
`sudo mount -o rw,noatime,remount /`

and revert to read-only when finished:  
`sudo mount -o ro,noatime,remount /`

Note that this setup is for a desktop system, it&#8217;s probably not appropriate for a server.

**Update:**  
If you have plenty of RAM (such as at least 1 GB), then you can also mount `/var/cache/apt` as `tmpfs`. That helps if you have limited free space on `/` and want to to a distribution upgrade.

Add this to `/etc/init.d/mountkernfs.sh`:

```
domount tmpfs "" /var/cache/apt -omode=0755,nodev,noexec,nosuid,size=1g
mkdir -p /var/cache/apt/archives/partial

```

And add this to `/etc/init.d/mtab.sh`:

```
domtab tmpfs /var/cache/apt "varcacheapt" -omode=0755,nodev,noexec,nosuid,size=1g

```

 [1]: http://en.wikipedia.org/wiki/Malware
 [2]: http://www.ubuntu.com/
 [3]: https://bugs.launchpad.net/ubuntu/+source/dhcp3/+bug/251632