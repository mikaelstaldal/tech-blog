---
title: How to setup PPTP VPN in Linux
author: Mikael Ståldal
type: post
date: 2009-01-19T17:36:17+00:00
slug: how-to-setup-pptp-vpn-in-linux
category:
  - Linux

---
1. Create a file `/etc/ppp/peers/name`:  
```
pty "pptp host --nolaunchpppd"
name username
remotename PPTP
require-mppe-128
file /etc/ppp/options.pptp
ipparam name
``` 
2. Add this line to the file `/etc/ppp/chap-secrets`:  
```
username PPTP password *
``` 

3. Create a file `/etc/ppp/ip-up.d/tunnel`  
```
#!/bin/sh
if [ "${PPP_IPPARAM}" = "name" ]; then
   route add -net RemoteNetworkWithNetmask dev ${PPP_IFACE}
fi
``` 

**RemoteNetworkWithNetmask** is the network on the remote side you want to access via the VPN tunnel, e.g. `172.16.0.0/12`.

Connect by running `sudo pon name`  
Disconnect by running `sudo poff`  
Check what happends by running `plog`

You can setup several VPN connections with different names, but I&#8217;m not sure if it&#8217;s possible to connect to more than one at the same time.

This is tested in Ubuntu desktop 8.04 (hardy) desktop.