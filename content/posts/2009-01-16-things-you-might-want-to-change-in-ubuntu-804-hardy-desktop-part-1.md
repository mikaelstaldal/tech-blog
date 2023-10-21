---
title: Things you might want to change in Ubuntu 8.04 (hardy) desktop, part 1
author: Mikael Ståldal
type: post
date: 2009-01-16T17:45:52+00:00
slug: things-you-might-want-to-change-in-ubuntu-804-hardy-desktop-part-1
category:
  - Linux

---
After installing [Ubuntu][1] 8.04 (hardy) desktop, there are some things you might want to change. This article focus on system configuration (mostly editing in `/etc`) and requires superuser access (using sudo). Some of this changes requires reboot to take effect.

##### Fix terminal font rendering bug

There is a bug which gives bad font rendering in the terminal window. Fix it by doing this in a terminal:

```
cd /etc/fonts/cond.d
sudo unlink 10-hinting-medium.conf
sudo ln -s ../conf.avail/10-hinting-full.conf

```

##### Fix bug in DHCP client

Fix a bug in the DHCP client described [here][2].

##### Use GNU nano as default console text editor instead of vi

Add this line to `/etc/profile`:

```
export EDITOR=nano

```

##### Mount `/tmp` as tmpfs if you have plenty of RAM

Add this to `/etc/init.d/mountkernfs.sh`:

```
32a33,35
>       domount tmpfs "" /tmp -omode=1777,nodev,exec,nosuid
>       # this is necessary to avoid that files are removed later in the boot process
>       touch /tmp/.clean

```

And add this to `/etc/init.d/mtab.sh`:

```
100a101,101
>       domtab tmpfs /tmp "tmp" -omode=1777,nodev,exec,nosuid

```

##### Increase the limit of number of open files

Add this to `/etc/security/limits.conf`:

```
42a43,44
> *               hard    nofile          65536
> *               soft    nofile          65536

```

##### Setup some useful NTP servers and sync clock at each login

Setup some useful NTP servers in `/etc/default/ntpdate`.

Create a file `/etc/X11/gdm/PostLogin/Default`:

```
#!/bin/sh
#
# This script will be run before any setup is run on behalf of the user and is
# useful if you for example need to do some setup to create a home directory
# for the user or something like that.  $HOME, $LOGIN and such will all be
# set appropriately and this script is run as root.

ntpdate-debian -s
if [ $? -gt 0 ];
then
        logger -p user.err "ntpdate failed"
        zenity --warning --text "ntpdate failed"
else
        logger -p user.info "ntpdate successful"
fi

```

See also [packages you might want to remove][3].

 [1]: http://www.ubuntu.com/
 [2]: https://bugs.launchpad.net/ubuntu/+source/dhcp3/+bug/251632
 [3]: http://www.staldal.nu/tech/2008/12/08/packages-you-might-want-to-remove-from-ubuntu-804-hardy-desktop/