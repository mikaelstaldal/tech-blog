---
title: Linux on diskless workstation
author: Mikael Ståldal
type: post
date: 2007-03-28T17:13:40+00:00
slug: linux-on-diskless-workstation
category:
  - Linux

---
When the built-in HDD controller in my computer broke down, I decided to try running my computer diskless with LAN booting. I use [Ubuntu Linux][1] 6.10 and I have another computer with a large HDD acting as server.

I followed the instructions in [this HOWTO][2]. I changed MODULES to &#8220;netboot&#8221; in `initramfs.conf` and I had to add a driver for my network adapter to the `modules` file in the initramfs configuration. It took me a while to realize why it didn&#8217;t work without the network adapter driver. I also mounted `/tmp` as tmpfs.

However, I did not had any installation to copy onto the server since I couldn&#8217;t access my HDD. I had to install Ubuntu on an old laptop and copy that installation to the server. I wish that the installation program for Ubuntu had support for installing onto a server for diskless operation. It should be easy to add that support.

Now when I finally got everything working, it works fine. Why have a HDD in every computer?

 [1]: http://www.ubuntu.com/
 [2]: https://help.ubuntu.com/community/DisklessUbuntuHowto