---
title: 'Secure your Go builds with AppArmor'
slug: go-apparmor
author: 'Mikael Ståldal'
type: post
date: 2025-09-14T20:00:00+02:00
year: 2025
month: 2025/09
day: 2025/09/14
category:
  - Linux
  - AppArmor
---

If you have a Linux system with [AppArmor](https://en.wikipedia.org/wiki/AppArmor), you can use it to secure your [Go](https://go.dev/) builds.

First install Go in `/usr/local/go` as in the [the instructions](https://go.dev/doc/install).

Then add this file to `/etc/apparmor.d`, replace `${HOME}` with your home directory.

```
#include <tunables/global>

profile go /usr/local/go/bin/go {
    #include <abstractions/base>
    #include <abstractions/consoles>
    /tmp/ r,
    /tmp/** rwkix,
    @{PROC}/** r,
    /sys/** r,
    /dev/** r,
    /etc/** r,
    /usr/** r,
    /bin/** ix,
    /usr/bin/** ix,
    /usr/libexec/** ix,
    /usr/lib/** ix,

    /usr/local/go/** rix,

    owner @{HOME}/.config/go/** rw,
    owner @{HOME}/.cache/go-build/** rwkix,
    owner @{HOME}/.cache/JetBrains/IntelliJIdea*/tmp/GoLand/** rwkix,
    owner @{HOME}/.cache/JetBrains/IntelliJIdea*/coverage/** rwk,
    owner @{HOME}/.local/share/JetBrains/IntelliJIdea*/go-plugin/** rix,
    owner @{HOME}/.config/dlv/** r,
    owner @{HOME}/.gitconfig r,
    owner @{HOME}/.gitignore r,
    owner @{HOME}/go/** rwkl,
    owner @{HOME}/go/bin/* rwklix,
    owner @{HOME}/src/** rwk,

    /etc/resolv.conf r,
    @{PROC}/sys/net/** r,
    /run/systemd/resolve/** r,
    network,

    signal (receive) set=(int,term,kill),

    ptrace,
}

profile go-fmt /usr/local/go/bin/gofmt {
    #include <abstractions/base>
    #include <abstractions/consoles>
    /tmp/** rwkix,

    /usr/local/go/** rix,

    owner @{HOME}/.config/go/** rw,
    owner @{HOME}/.cache/JetBrains/IntelliJIdea*/tmp/GoLand/** rwk,
    owner @{HOME}/go/** rwk,
    owner @{HOME}/src/** rwk,

    signal (receive) set=(int,term,kill),
}

profile go-bin ${HOME}/{go/bin/*,.cache/go-build/**,.cache/JetBrains/IntelliJIdea*/tmp/GoLand/*} {
    #include <abstractions/base>
    #include <abstractions/consoles>
    /etc/** r,
    /bin/** ix,
    /usr/bin/** ix,
    /tmp/ r,
    /tmp/** rwk,

    /usr/local/go/** rix,

    owner @{HOME}/.config/go/** r,
    owner @{HOME}/.cache/go-build/** rix,
    owner @{HOME}/.cache/JetBrains/IntelliJIdea*/tmp/GoLand/** rix,
    owner @{HOME}/go/** r,
    owner @{HOME}/go/bin/* rix,
    owner @{HOME}/src/** r,

    /etc/resolv.conf r,
    @{PROC}/sys/net/** r,
    /run/systemd/resolve/** r,
    network,

    signal (receive) set=(int,term,kill),

    ptrace (tracedby, readby) peer=go,
}

```
Then run `sudo service apparmor reload` to activate it (it will be loaded automatically on boot). This is tested un Ubuntu desktop 24.04.
It will also enable use of the Go plugin to IntelliJ IDEA.

