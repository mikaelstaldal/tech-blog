---
title: 'Sandbox IntelliJ IDEA with AppArmor'
slug: intellij-apparmor
author: 'Mikael Ståldal'
type: post
date: 2025-10-19T17:00:00+02:00
year: 2025
month: 2025/10
day: 2025/10/19
category:
  - Linux
  - AppArmor
---

If you have a Linux system with [AppArmor](https://en.wikipedia.org/wiki/AppArmor), you can use it to sandbox [IntelliJ IDEA](https://www.jetbrains.com/idea/).

Do not install IntelliJ with snap, download the `.tar.gz` archive instead and unpack it in `/opt/JetBrains/`.

Then add this file to `/etc/apparmor.d`.

```
#include <tunables/global>

profile idea /opt/JetBrains/idea*/bin/* {
    #include <abstractions/base>
    #include <abstractions/consoles>
    #include <abstractions/nameservice>
    #include <abstractions/ssl_certs>
    #include <abstractions/gnome>
    #include <abstractions/xdg-open>
    #include <abstractions/dbus-session>
    
    /etc/** r,
    /dev/** r,
    /dev/ptmx rw,
    @{PROC}/ r,
    @{PROC}/** r,
    /sys/** r,
    /bin/* rixm,
    /usr/bin/{[^s]*,?[^n]*,??[^a]*,???[^p]*} rixm,
    /usr/local/bin/** rixm,
    /usr/include/** r,
    /usr/lib/ r,
    /usr/lib/** rixm,
    /usr/lib64/ r,
    /usr/lib64/** rixm,
    /usr/libexec/** rixm,
    /usr/sbin/* rixm,
    /usr/share/** r,

    /{,snap/core/[0-9]*/,snap/snapd/[0-9]*/}usr/bin/snap mrCx -> snap_browsers,

    owner @{PROC}/@{pid}/coredump_filter rw,
    owner /tmp/ r,
    owner /tmp/** rwlkix,
    owner /var/tmp/ r,
    owner /var/tmp/** rwlkix,
    owner /run/user/@{uid}/at-spi/* rw,
    owner /run/user/@{uid}/bus rw,
    owner /run/user/@{uid}/dconf/user rw,
    owner /run/user/@{uid}/gdm/Xauthority r,
    owner /run/user/@{uid}/keyring/ssh rw,

    /opt/JetBrains/** rixm,

    / r,
    /home/ r,
    owner @{HOME}/ r,
    owner @{HOME}/.bashrc r,
    owner @{HOME}/.bash_aliases r,
    owner @{HOME}/.cache/JNA/*/ r,
    owner @{HOME}/.cache/JetBrains/ r,
    owner @{HOME}/.cache/JetBrains/** rwklix,
    owner @{HOME}/.cache/ibus/* rw,
    owner @{HOME}/.config/JetBrains/ r,
    owner @{HOME}/.config/JetBrains/** rwkl,
    owner @{HOME}/.config/dconf/user r,
    owner @{HOME}/.config/ibus/bus/ r,
    owner @{HOME}/.config/ibus/bus/* r,
    owner @{HOME}/.gitconfig r,
    owner @{HOME}/.gitignore r,
    owner @{HOME}/.gradle/ r,
    owner @{HOME}/.gradle/** rwklixm,
    owner @{HOME}/.inputrc r,
    owner @{HOME}/.ivy2/** rwkl,
    owner @{HOME}/.java/** rwkl,
    owner @{HOME}/.junie/ r,
    owner @{HOME}/.junie/** rwkl,
    owner @{HOME}/.local/bin/* rix,
    owner @{HOME}/.local/share/JetBrains/ r,
    owner @{HOME}/.local/share/JetBrains/** rwklix,
    owner @{HOME}/.local/share/kotlin/** rwklix,
    owner @{HOME}/.m2/ r,
    owner @{HOME}/.m2/** rwkl,
    owner @{HOME}/.profile r,
    owner @{HOME}/.ssh/ r,
    owner @{HOME}/.ssh/config r,
    owner @{HOME}/.ssh/known_hosts* r,
    owner @{HOME}/.ssh/*.pub r,
    owner @{HOME}/src/ r,
    owner @{HOME}/src/** rwklix,

    signal (send,receive) set=(int,term,kill) peer=idea,

    ptrace peer=idea,

	profile snap_browsers {
	  #include <abstractions/base>
	  #include <abstractions/dbus-session-strict>

	  /etc/passwd r,
	  /etc/nsswitch.conf r,
	  /etc/fstab r,
 	  /etc/local/fstab r,

	  # noisy
	  deny owner /run/user/[0-9]*/gdm/Xauthority r, # not needed on Ubuntu

	  /{,snap/core/[0-9]*/,snap/snapd/[0-9]*/}usr/bin/snap mrix, # re-exec
	  /{,snap/core/[0-9]*/,snap/snapd/[0-9]*/}usr/lib/snapd/info r,
	  /{,snap/core/[0-9]*/,snap/snapd/[0-9]*/}usr/lib/snapd/snapd r,
	  /{,snap/core/[0-9]*/,snap/snapd/[0-9]*/}usr/lib/snapd/snap-seccomp rPix,
	  /{,snap/core/[0-9]*/,snap/snapd/[0-9]*/}usr/lib/snapd/snap-confine Pix,
	  /var/lib/snapd/system-key r,
	  /run/snapd.socket rw,

	  /usr/bin/systemctl ix,

	  @{PROC}/version r,
	  @{PROC}/cmdline r,
	  @{PROC}/sys/net/core/somaxconn r,
	  @{PROC}/sys/kernel/seccomp/actions_avail r,
	  @{PROC}/sys/kernel/random/uuid r,
	  owner @{PROC}/@{pid}/cgroup r,
	  owner @{PROC}/@{pid}/mountinfo r,
	  owner @{HOME}/.snap/auth.json r, # if exists, required

	  dbus send bus="session" path="/org/freedesktop/systemd1" interface="org.freedesktop.systemd1.Manager" member="StartTransientUnit" peer=(name="org.freedesktop.systemd1"),
	  dbus receive bus="session" path="/org/freedesktop/systemd1" interface="org.freedesktop.systemd1.Manager" member="JobRemoved",

	  /sys/fs/cgroup/cgroup.controllers r,
	  /sys/kernel/security/apparmor/features/ r,
          /sys/kernel/security/apparmor/features/** r,

	  # allow launching official browser snaps.
	  /snap/{brave,chromium,firefox,opera}/[0-9]*/meta/{snap.yaml,hooks/} r,
	  /var/lib/snapd/sequence/{brave,chromium,firefox,opera}.json r,
	  /var/lib/snapd/inhibit/{brave,chromium,firefox,opera}.lock rk,
	}

}

```
Then run `sudo service apparmor reload` to activate it (it will be loaded automatically on boot). This is tested on Ubuntu desktop 24.04.

You need to disable the embedded Chrome browser by setting `ide.browser.jcef.enabled=false` in the [registry](https://stackoverflow.com/questions/28415695/how-do-you-set-a-value-in-the-intellij-registry#28419108).

Now IntelliJ IDEA will have access to projects in `~/src`, but not to the rest of your home directory.
