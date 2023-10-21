---
title: Mount your home directory with SSHFS in Linux
author: Mikael Ståldal
type: post
date: 2010-08-21T20:25:11+00:00
url: /2010/08/21/mount-your-home-directory-with-sshfs-in-linux/
category:
  - Linux

---
If you have your home directory on another machine, it&#8217;s common to use [NFS][1] to access it. NFS is easy to set up and works more or less out of the box on Linux. However, NFS is not secure, and you need to have a carefully setup firewall in order to use it safely.

[SSHFS][2] is a more secure alternative, but it&#8217;s quite tricky to set up on the client side. It&#8217;s very easy to set up on the server though, you just need an SSH server with SFTP support.

This is the way to set up it on the client using Ubuntu desktop 10.04:

1. First you have to get rid of the file `.ICEauthority` from your home directory. Create a `.gnomerc` file in your home directory: 
```
mkdir "/tmp/.ICE-${USER}"
export ICEAUTHORITY="/tmp/.ICE-${USER}/.ICEauthority"
```

2. Then you need to setup a local bootstrap home directory containing this `.gnomerc` file and your `.ssh` directory including your private key file. The remote home directory will be mounted over this. This can be on a [read-only filesystem][3]. You need to modify your `.ssh/config` file to explicitly point out your private key and known hosts files, add this: 
```
IdentityFile /home/username/.ssh/identity
IdentityFile /home/username/.ssh/id_rsa
IdentityFile /home/username/.ssh/id_dsa
UserKnownHostsFile /home/username/.ssh/known_hosts
```

3. Setup mounting on login by adding this to `/etc/gdm/PostLogin/Default`: 
```
sshfs -F ${HOME}/.ssh/config -o nonempty -o allow_other -o default_permissions ${USER}@theserver: ${HOME}
```

4. Setup umounting on logout by adding this to `/etc/gdm/PostSession/Default` 
```
fusermount -u -z ${HOME}
```

 [1]: http://en.wikipedia.org/wiki/Network_File_System_%28protocol%29
 [2]: http://fuse.sourceforge.net/sshfs.html
 [3]: http://www.staldal.nu/tech/2009/11/15/linux-with-mounted-read-only-2-0/