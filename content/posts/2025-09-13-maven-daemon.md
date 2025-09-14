---
title: 'Speed-up and secure your Maven builds with Maven Daemon'
slug: maven-daemon
author: 'Mikael Ståldal'
type: post
date: 2025-09-13T20:00:00+02:00
year: 2025
month: 2025/09
day: 2025/09/13
category:
  - Java
  - maven
  - Linux
  - AppArmor  
---

You can speed-up Maven builds considerably by using [Maven Daemon](https://maven.apache.org/tools/mvnd.html).

Here is how I installed it on Ubuntu Linux:

1. Make sure you have a Java Development Kit installed.

2. Set the `JAVA_HOME` environment variable to point to your JDK by creating a file `/etc/profile.d/java.sh` with this content:
   
   ```shell
   #!/bin/sh
   export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
   ```

3. [Download Maven Daemon](https://downloads.apache.org/maven/mvnd/).

4. Unpack it into `/opt`

5. Make it available in PATH:
   
   ```shell
   $ cd /usr/bin
   $ sudo ln -s ../../opt/maven-mvnd-1.0.2-linux-amd64/bin/mvnd .
   $ sudo ln -s mvnd mvn
   ```

You can configure IntelliJ IDEA to use it by setting `Maven home path` to `/opt/maven-mvnd-1.0.2-linux-amd64`.
You need to do this for all existing Maven projects you have. Also make sure that the 
[registry](https://youtrack.jetbrains.com/articles/SUPPORT-A-1030) setting `maven.use.scripts` is true.

You can secure your Maven builds with [AppArmor](https://en.wikipedia.org/wiki/AppArmor). Add this file to `/etc/apparmor.d`:

```
#include <tunables/global>

profile maven /opt/maven-mvnd-*/{bin/mvnd,mvn/bin/mvn} {
    #include <abstractions/base>
    #include <abstractions/consoles>

    /tmp/ r,
    /tmp/** rwklix,

    @{PROC}/ r,
    @{PROC}/** r,
    @{PROC}/@{pid}/** rwk,

    /opt/maven-mvnd-*/** r,

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
    owner @{HOME}/.m2/** rwkl,

    /snap/intellij-idea-ultimate/** r,

    /etc/resolv.conf r,
    @{PROC}/sys/net/** r,
    /run/systemd/resolve/** r,
    network,

    signal (receive) set=(int,term,kill),

    ptrace,
}
```

Then run `sudo service apparmor reload` to activate it (it will be loaded automatically on boot). This is tested un Ubuntu desktop 24.04.
Some Maven plugins require additional configuration to function properly.
