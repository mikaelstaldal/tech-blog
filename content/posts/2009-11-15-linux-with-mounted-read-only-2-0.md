---
title: Linux with / mounted read-only 2.0
author: Mikael Ståldal
type: post
date: 2009-11-15T11:15:05+00:00
url: /2009/11/15/linux-with-mounted-read-only-2-0/
category:
  - Linux

---
(This is a new version of a [previous post][1] updated to work with Ubuntu 9.10 (karmic).)

I wondered why you usually mount / (the root file system) read-write in Linux and decided to do some experiments to find out if it is possible to have it mounted read-only. 

So why do you want to do that? Perhaps you have the root file system on a read-only media, such as CD-ROM. Or on a writable media which can only handle a limited number of writes, such as a CD-RW or flash disk. It would also increase security since it will be more difficult (though not impossible) for some [malware][2] to infect your system.

I found out that it is possible to mount / read-only, but only after some tweaking. Here is how I did it in [Ubuntu][3] 9.10 (karmic) desktop.

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
  * `/var/lib/nfs` (only if you use NFS)
  * `/var/spool/cups`

Ubuntu mounts `/var/run` and `/var/lock` as `tmpfs` by default. This is done by the `mountall` tool.

Add this to `/etc/fstab`:

```
none /tmp             tmpfs mode=1777,nodev,exec,nosuid 0 0
none /media           tmpfs mode=0755,nodev,noexec,nosuid 0 0
none /var/tmp         tmpfs mode=1777,nodev,noexec,nosuid 0 0
none /var/crash       tmpfs mode=0755,nodev,noexec,nosuid 0 0
none /var/spool/cups  tmpfs mode=0710,nodev,noexec,nosuid,gid=lp 0 
none /var/log         tmpfs mode=0755,nodev,noexec,nosuid 0 0
none /var/lib/dhcp3   tmpfs mode=0755,nodev,noexec,nosuid 0 0
none /var/lib/xkb     tmpfs mode=0755,nodev,noexec,nosuid 0 0
none /var/lib/gdm     tmpfs mode=0775,nodev,noexec,nosuid,gid=gdm 0 0
none /var/lib/nfs     tmpfs mode=0755,nodev,noexec,nosuid 0 0

```

And add this to `/etc/rc.local`:

```
mkdir /var/log/apt

```

There are some files in `/etc` which have to be writeable:

  * `/etc/mtab`
  * `/etc/resolv.conf` (only if you use DHCP client and let it set DNS configuration)

I handle `/etc/mtab` by symlink it to `/proc/mounts`, that has some minor side-effects but I can live with it. I handle `/etc/resolv.conf` by symlinking it to `/var/lib/dhcp3/resolv.conf`. In order for this to work, you have to patch the DHCP client (dhcp3-client) accodring to [this bug report][4] (use the new version of the patch).

You also have to mount `/home` read-write somewhere, and I would not recommend using `tmpfs`. You can use a separate hard disk partition or NFS.

It is a bit tricky to get this to work with NFS. You have to set the NFS mount points in `/etc/fstab` as `noauto` and add these lines to `/etc/init/statd.conf` just before `status portmap...`

```
mkdir /var/lib/nfs/sm
mkdir /var/lib/nfs/sm.bak
mkdir /var/lib/nfs/rpc_pipefs

```

Then mount the NFS shares in `/etc/gdm/PostLogin/Default`. For some reason it did not work to do it from `/etc/rc.local`, perhaps due to delay in DHCP lookup.

Finally it might be a good idea to set a password for the root account, this enables you to switch to a virtual console (`Ctrl`&#8211;`Alt`&#8211;`F1`) and login as root if something goes wrong.

If you then do want to change anything, such as edit a file in `/etc` or install or upgrade a package, you can just remount / as read-write temporary (assuming that the media actually is writeable):  
`sudo mount -o rw,noatime,remount /`

and revert to read-only when finished:  
`sudo mount -o ro,noatime,remount /`

Note that this setup is for a desktop or laptop system, it&#8217;s probably not appropriate for a server.

If you have plenty of RAM (such as at least 1 GB), then you can also mount `/var/cache/apt` as `tmpfs`. That helps if you have limited free space on `/` and want to do a distribution upgrade.

Add this to `/etc/fstab`:

```
none /var/cache/apt   tmpfs mode=0755,nodev,noexec,nosuid 0 0

```

And add this to `/etc/rc.local`:

```
mkdir -p /var/cache/apt/archives/partial

```

 [1]: http://www.staldal.nu/tech/2008/07/26/linux-with-mounted-read-only/
 [2]: http://en.wikipedia.org/wiki/Malware
 [3]: http://www.ubuntu.com/
 [4]: https://bugs.launchpad.net/ubuntu/+source/dhcp3/+bug/251632