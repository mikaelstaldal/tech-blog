---
title: 'Linux sandboxing with bubblewrap'
slug: linux-sandboxing-with-bubblewrap
author: 'Mikael Ståldal'
type: post
date: 2025-10-19T18:00:00+02:00
year: 2025
month: 2025/10
day: 2025/10/19
category:
  - Linux

---

[AppArmor](https://en.wikipedia.org/wiki/AppArmor) is a good way to sandbox programs on a Linux system, but it has some limitations.
In particular, it requires you to define a static profile for each program, and changing profiles requires root access. This can be
impractical for ad-hoc usages, and in particular if you want to give the program access to a particular directory (such as the current 
directory). These gaps can be filled with [bubblewrap](https://github.com/containers/bubblewrap).

Here is how you can use it on Ubuntu 24.04.

Install bubblewrap:

```bash
sudo apt install bubblewrap
```

Create an AppArmor profile for bubblewrap so that it can use [user namespaces](https://discourse.ubuntu.com/t/understanding-apparmor-user-namespace-restriction/58007), 
you can use [this one](https://gitlab.com/apparmor/apparmor/-/blob/1979af7710d0f38db6680bd7c19c80902f11f969/profiles/apparmor/profiles/extras/bwrap-userns-restrict). 
Hopefully this will be included by default in future versions of Ubuntu, but as of 24.04 you need to install it manually. 
Put the file in `/etc/apparmor.d` and run:

```bash
sudo service apparmor reload
```

Then you can sandbox a program like this:

```bash
bwrap \
  --ro-bind /usr/bin /usr/bin \
  --ro-bind /usr/sbin /usr/sbin \
  --ro-bind /usr/lib /usr/lib \
  --ro-bind /usr/lib64 /usr/lib64 \
  --ro-bind /usr/share /usr/share \
  --symlink /usr/lib /lib \
  --symlink /usr/lib64 /lib64 \
  --symlink /usr/bin /bin \
  --symlink /usr/sbin /sbin \
  --proc /proc \
  --dev /dev \
  --bind "$(pwd)" "$(pwd)" \
  --chdir "$(pwd)" \
  --unshare-all \
  --new-session \
  --ro-bind /path/to/program /path/to/program \
  /path/to/program/the_program "$@"
```

It will only have access to the current directory, not the rest of the file system, and no network access. 
Replace `--bind "$(pwd)" "$(pwd)"` with `--ro-bind "$(pwd)" "$(pwd)"` to give only read-only access to current directory, remove it to not give any access to current directory.
Add `--share-net` to give network access. See the [man page](https://manpages.ubuntu.com/manpages/noble/en/man1/bwrap.1.html) for more options.

This can be combined with a static AppArmor profile for the program to achieve stronger sandboxing, but then the AppArmor profile needs to grant access to all parts of the 
file system you ever want to be able to access, e.g. `owner @{HOME}/** rwkl,`.
