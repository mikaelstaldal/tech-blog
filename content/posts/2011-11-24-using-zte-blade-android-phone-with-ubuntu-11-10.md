---
title: Using ZTE Blade Android phone with Ubuntu 11.10
author: Mikael Ståldal
type: post
date: 2011-11-24T17:08:13+00:00
url: /2011/11/24/using-zte-blade-android-phone-with-ubuntu-11-10/
categories:
  - Linux

---
Using a ZTE Blade Android phone connected with USB is a bit tricky with Ubuntu 11.10.

First you need to apply the patch in [this bug][1], after doing that you should get USB storage to work.

After doing that, it is also possible to get development and debugging to work over USB. Create a group `androiddev` (`addgroup --system androiddev`), and add yourself to it (`gpasswd -a yourUsername androiddev`). Then create a file `/etc/udev/rules.d/11-android.rules` with this content (4 lines, watch the line breaks):

> SUBSYSTEMS==&#8221;usb&#8221;, ATTRS{idVendor}==&#8221;19d2&#8243;, ATTRS{idProduct}==&#8221;1353&#8243;, MODE=&#8221;0666&#8243;, OWNER=&#8221;root&#8221;, GROUP=&#8221;androiddev&#8221; #Normal Blade  
> SUBSYSTEMS==&#8221;usb&#8221;, ATTRS{idVendor}==&#8221;19d2&#8243;, ATTRS{idProduct}==&#8221;1350&#8243;, MODE=&#8221;0666&#8243;, OWNER=&#8221;root&#8221;, GROUP=&#8221;androiddev&#8221; #Debug Blade  
> SUBSYSTEMS==&#8221;usb&#8221;, ATTRS{idVendor}==&#8221;19d2&#8243;, ATTRS{idProduct}==&#8221;1354&#8243;, MODE=&#8221;0666&#8243;, OWNER=&#8221;root&#8221;, GROUP=&#8221;androiddev&#8221; #Recovery Blade  
> SUBSYSTEMS==&#8221;usb&#8221;, ATTRS{idVendor}==&#8221;18d1&#8243;, ATTRS{idProduct}==&#8221;d00d&#8221;, MODE=&#8221;0666&#8243;, OWNER=&#8221;root&#8221;, GROUP=&#8221;androiddev&#8221; #Fastboot Blade 

Finally logout and login again. Don&#8217;t forget to enable USB debugging on the phone before connecting it.

Depending on the exact model you have, you might need to adjust the file. See what the `lsusb` command says about your phone and put that product id in the second line.

 [1]: https://bugs.launchpad.net/ubuntu/+source/usb-modeswitch-data/+bug/894448