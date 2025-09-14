---
title: 'Secure your Gradle builds with AppArmor'
slug: gradle-apparmor
author: 'Mikael Ståldal'
type: post
date: 2025-09-14T10:00:00+02:00
year: 2025
month: 2025/09
day: 2025/09/14
category:
  - Java
  - gradle
  - Linux
  - AppArmor  
---

If you have a Linux system with [AppArmor](https://en.wikipedia.org/wiki/AppArmor), you can use it to secure your [Gradle](https://gradle.org/) builds.

Here is how I installed it on Ubuntu Linux:

1. Make sure you have a Java Development Kit installed.

2. Set the `JAVA_HOME` environment variable to point to your JDK by creating a file `/etc/profile.d/java.sh` with this content:
   
   ```shell
   #!/bin/sh
   export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
   ```

3. Make a [manual installation](https://docs.gradle.org/current/userguide/installation.html#linux_installation) of Gradle in `/opt/gradle`.

4. Make it available in PATH:
   
   ```shell
   $ cd /usr/bin
   $ sudo ln -s ../../opt/gradle/gradle-8.14.3/bin/gradle .
   ```

Add this file to `/etc/apparmor.d`:

```
#include <tunables/global>

profile gradle /opt/gradle/gradle-*/bin/gradle {
    #include <abstractions/base>
    #include <abstractions/consoles>

    /tmp/ r,
    /tmp/** rwklix,

    @{PROC}/ r,
    @{PROC}/** r,
    @{PROC}/@{pid}/** rwk,

    /opt/gradle/** r,

    /sys/** r,
    /etc/** r,
    /usr/share/** r,
    /bin/** ix,
    /usr/bin/** ix,
    /usr/sbin/ldconfig rix,
    /usr/sbin/ldconfig.real ix,
    /usr/lib/** rix,

    owner @{HOME}/src/** rwkl,
    owner @{HOME}/.java/** rwk,
    owner @{HOME}/.cache/JNA/** rwkm,
    owner @{HOME}/.gradle/** rwklm,
    owner @{HOME}/.konan/** rwkl,
    owner @{HOME}/.m2/** rwkl,
    owner @{HOME}/.local/share/kotlin/** r,
    owner @{HOME}/.local/share/kotlin/daemon/** rwkl,

    /snap/intellij-idea-ultimate/** r,

    /etc/resolv.conf r,
    @{PROC}/sys/net/** r,
    /run/systemd/resolve/** r,
    network,

    signal (receive) set=(int,term,kill),
}
```

Then run `sudo service apparmor reload` to activate it (it will be loaded automatically on boot). This is tested un Ubuntu desktop 24.04.
Some Gradle plugins require additional configuration to function properly. I have not been able to make this work reliably with IntelliJ IDEA.
