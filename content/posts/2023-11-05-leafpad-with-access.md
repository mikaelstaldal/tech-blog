---
title: 'Leafpad with access to system files'
slug: leafpad-with-access
author: 'Mikael Ståldal'
type: post
date: 2023-11-05T18:50:39+01:00
year: 2023
month: 2023/11
day: 2023/11/05
category:
  - Linux
  - Ubuntu

---
As I [have explained earlier](/tech/2015/07/21/leafpad-gedit/), I am using [Leafpad](http://tarot.freeshell.org/leafpad/) 
instead of [gedit](https://gedit-technology.github.io/apps/gedit/) in my Ubuntu system.

However, recent versions of Ubuntu does not have Leafpad available through APT any longer, you have to install it with 
Snap instead. This is quite annoying, since the Snap packaging of Leafpad is too restrictive, it cannot access hidden
files in your home directory, nor anything in `~/bin/`. This is not good, since I often want to use Leafpad to edit 
such files.

I did not find any way to fix this with Snap, so I uninstalled the Leafpad snap, and built it from source instead:

1. sudo apt install libgtk2.0-dev
2. wget http://savannah.nongnu.org/download/leafpad/leafpad-0.8.17.tar.gz
3. tar -xzf leafpad-0.8.17.tar.gz
4. cd leafpad-0.8.17
5. ./configure
6. make
7. sudo make install-strip
