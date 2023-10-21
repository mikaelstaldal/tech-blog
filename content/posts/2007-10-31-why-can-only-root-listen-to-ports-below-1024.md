---
title: Why can only root listen to ports below 1024?
author: Mikael Ståldal
type: post
date: 2007-10-31T17:15:47+00:00
url: /2007/10/31/why-can-only-root-listen-to-ports-below-1024/
category:
  - Linux
  - security

---
_(This article has been edited since it&#8217;s first publication.)_

In Linux, and other UNIX-like systems, you have to be root (have superuser privileges) in order to listen to TCP or UDP ports below 1024 (the _well-known ports_).

This port 1024 limit is a security measure. But it is based on an obsolete security model and today it only gives a false sense of security and contributes to security holes.

The port 1024 limit forces you to run all network daemons with  
superuser privileges, which might open security holes. Without the port 1024 limit, most network daemons (except `sshd`), could be run without superuser privileges. Some daemons try to remedy this potential security hole by dropping the superuser privileges after binding to the port, but you still need to start the daemon as root. And this does not work if the daemon is written in Java, which is quite popular for web servers.

Today the typical Linux machine is not used in a way which makes the port 1024 limit relevant. Either you use it as a desktop client (workstation) with only one user which have superuser access via `sudo`. In the desktop case the limit is a source of frustration since you have to use `sudo` more often than necessary. 

Or you use it as a firewall, router or web/database/DNS/mail/news server and then only trusted administrators can login at all. The database or web application have it&#8217;s own user account system separate from the system&#8217;s and these untrusted users cannot install any daemons at all.

And even if you use a Linux machine in a way where the port 1024 limit could be useful, i.e. allowing untrusted users to login, you&#8217;d better not count on it. If a malicious user can login to a normal unprivileged account, it might be possible to exploit some security hole and gain superuser access. So if you allow untrusted users to login to a Linux machine, you should not use that machine for anything else and the daemons running on that machine should not be trusted.

The port 1024 limit actually bites itself in the tail. It forces a daemon practice that might open security holes which make the limit ineffective as a security measure.

I do not blame those who invented the port 1024 limit, it was a natural and important security feature given how UNIX machines was used in 1970&#8217;s and 1980&#8217;s. A typical UNIX machine allowed a bunch of not necessary fully trusted people to log in and do stuff. You don&#8217;t want these untrusted users to be able to install a custom daemon pretending to be a well-known service such as `telnet` or `ftp` since that could be used to steal passwords and other nasty things.

The port 1024 limit is part of the same security model that gave us the [rlogin][1] authentication. That security model is based on the assumption that every machine (but not every user) on the network can be trusted, that only trusted users have root access to any network connected machine and that all network connected machines have the same port 1024 limit.

It is well-known that this security model is obsolete and totally useless on the public Internet today. Virtually anyone can connect a computer to the pubic Internet and have root access, and there is at least one popular operating system without this port 1024 limit &#8211; Microsoft Windows.

Because of this, no sensible person uses rlogin authentication on an Internet connected network today (at least not without being protected by a carefully configured firewall). But the port 1024 limit is still there in Linux and most other UNIX style systems. I wonder why. Isn&#8217;t it time to declare the port 1024 limit as obsolete too and remove it?

It would probably not be a good idea to remove the port 1024 limit completely immediately. Some machines depend on the limit for security and their system configuration has to be properly adjusted. The solution is to make it configurable.

FreeBSD have a pair of `sysctl` parameters allowing you to adjust (or effectively remove) this port limit, `net.inet.ip.portrange.reservedlow` and `net.inet.ip.portrange.reservedhigh`. It would be nice if something similar was implemented in Linux (and in other UNIX-like systems). It&#8217;s probably not very useful to be able to adjust the lower part of the range, it can be fixed at 0.

But it would be very useful to adjust the higher part of the range from the current value 1023. If you set it to 79 you can run a web server without superuser privileges, but only root can bind to the lower ports (such as ssh).

 [1]: http://en.wikipedia.org/wiki/Rlogin