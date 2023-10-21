---
title: Packages you might want to remove from Ubuntu 8.04 (hardy) desktop
author: Mikael Ståldal
type: post
date: 2008-12-08T12:14:11+00:00
url: /2008/12/08/packages-you-might-want-to-remove-from-ubuntu-804-hardy-desktop/
category:
  - Linux

---
When you install Ubuntu 8.04 (hardy) desktop, you get a lot of packages installed by default. Most users will never use many of these packages, so you end up with a lot of unnecessary packages. Most of these packages are harmless and only waste disk space when not used.

However, some packages can actually affect the system in a negative way, such as draining resources (other then disk space), and you should consider removing them if you not actively use them.

To remove some of these packages, you also need to remove these metapackages:

```
ubuntu-desktop
ubuntu-standard
ubuntu-minimal

```

### Tracker

Tracker indexes your files in the background. This can slow down your computer considerably.

```
libtracker-gtk0
tracker
tracker-search-tool
libdeskbar-tracker

```

### Locate

Locate is another tool for indexing your files. It makes not much sense to have it in parallel with tracker.

```
mlocate

```

### Avahi

Some multicast DNS stuff. Contains a network daemon, and good security common sense tell you to remove all network daemons you don&#8217;t actually use.

```
avahi-autoipd
avahi-daemon
libavahi-core5
libnss-mdns

```

### Bluetooth stack

Quite useless if your computer doesn&#8217;t have Bluetooth.

```
bluez-audio
bluez-cups
bluez-gnome
bluez-utils

```

### Network Manager

Can be good to have on a laptop with wireless networking. But makes no sense if you have a permanent wired network connection (or no network connection at all).

```
network-manager
network-manager-gnome
libnm-glib0
libnm-util0

```

### Usplash

Display a pretty image during boot, hiding a lot of possibly interesting messages. Does not work with some display adapters.

```
usplash
usplash-theme-ubuntu
libusplash0

```

### Evolution

A groupware suite, contains a daemon (evolution-alarm-notify).

```
evolution
evolution-common
evolution-exchange
evolution-plugins
evolution-webcal
contact-lookup-applet
libexchange-storage1.2-3

```

### Vim

A text editor that some people finds very hard to use. Used by default by some commands such as `visudo`, so you might accidentally end up in a awkward text editor you don&#8217;t even know how to exit.

```
vim-common
vim-tiny

```