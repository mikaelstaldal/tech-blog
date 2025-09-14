---
title: 'Secure your Rust builds with AppArmor'
slug: rust-apparmor
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

If you have a Linux system with [AppArmor](https://en.wikipedia.org/wiki/AppArmor), you can use it to secure your [Rust](https://www.rust-lang.org/) builds.

First install Rust with [rustup](https://www.rust-lang.org/tools/install) in `~/.cargo/bin`.

Then add this file to `/etc/apparmor.d`, replace `${HOME}` with your home directory.

```
#include <tunables/global>

profile cargo-bin ${HOME}/{.cargo/bin/*,.local/share/JetBrains/IntelliJIdea*/intellij-rust/bin/linux/x64/*} {
    #include <abstractions/base>
    #include <abstractions/consoles>

    @{PROC}** r,
    /sys/** r,
    /usr/bin/** ix,
    /usr/include/** r,
    /usr/libexec/** rix,
    /usr/share/** r,
    /tmp/ r,
    /tmp/** rwkix,

    owner @{HOME}/.gitconfig r,
    owner @{HOME}/.gitignore r,
    owner @{HOME}/.rustup/** r,
    owner @{HOME}/.rustup/toolchains/** rix,
    owner @{HOME}/.cargo/ r,
    owner @{HOME}/.cargo/** rwkl,
    owner @{HOME}/.cargo/bin/** rwklix,
    owner @{HOME}/.local/share/JetBrains/IntelliJIdea*/intellij-rust/** r,
    owner @{HOME}/.local/share/JetBrains/IntelliJIdea*/intellij-rust/bin/linux/x64/* rix,
    owner @{HOME}/.cache/JetBrains/IntelliJIdea*/intellij-rust/** rwk,
    owner @{HOME}/src/** rwklix,

    /etc/resolv.conf r,
    @{PROC}/sys/net/** r,
    network,
    /run/systemd/resolve/** r,

    signal (receive) set=(int,term,kill),
}

profile rustup ${HOME}/.cargo/bin/rustup {
    #include <abstractions/base>
    #include <abstractions/consoles>

    /etc/** r,
    @{PROC}** r,
    /sys/** r,
    /usr/bin/** ix,
    /usr/include/** r,
    /usr/libexec/** rix,
    /usr/share/** r,
    /tmp/ r,
    /tmp/** rwkix,

    owner @{HOME}/.gitconfig r,
    owner @{HOME}/.gitignore r,
    owner @{HOME}/.rustup/** rwkl,
    owner @{HOME}/.rustup/toolchains/** rwklix,
    owner @{HOME}/.cargo/ r,
    owner @{HOME}/.cargo/** rwkl,
    owner @{HOME}/.cargo/bin/** rwklix,
    owner @{HOME}/.local/share/JetBrains/IntelliJIdea*/intellij-rust/** r,
    owner @{HOME}/.local/share/JetBrains/IntelliJIdea*/intellij-rust/bin/linux/x64/* rix,
    owner @{HOME}/.cache/JetBrains/IntelliJIdea*/intellij-rust/** rwk,
    owner @{HOME}/src/** rwklix,

    /etc/resolv.conf r,
    @{PROC}/sys/net/** r,
    network,
    /run/systemd/resolve/** r,

    signal (receive) set=(int,term,kill),
}

```
Then run `sudo service apparmor reload` to activate it (it will be loaded automatically on boot). This is tested un Ubuntu desktop 24.04.
It will also enable use of the Rust plugin to IntelliJ IDEA.
