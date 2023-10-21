---
title: Running Jetty as a service in Ubuntu Linix
author: Mikael Ståldal
type: post
date: 2014-10-02T10:05:28+00:00
url: /2014/10/02/running-jetty-as-a-service-in-ubuntu-linix/
categories:
  - Java
  - Linux
  - Ubuntu

---
[Jetty][1] is a popular open source Java application server. In order to run it as a service on a Linux server, they recommend using a [horribly overcomplicated and quite fragile script][2].

In Ubuntu server, there is a better way. Leverage [Upstart][3] and its declarative job definitions.

First install Jetty into `/opt/jetty` and create a `jetty` user:

```
useradd --user-group --shell /bin/false --home-dir /opt/jetty/temp jetty

```

Then create a file `/etc/init/jetty.conf` with content like this:

```
start on runlevel [2345]
stop on starting rc RUNLEVEL=[016]

chdir /opt/jetty

setuid jetty

reload signal SIGQUIT

exec /usr/local/lib/jvm/bin/java \
-Xmx512m \
-Djava.awt.headless=true \
-Djetty.state=/opt/jetty/jetty.state \
-Djetty.port=8080 \
-Djetty.home=/opt/jetty \
-Djava.io.tmpdir=/tmp \
-jar /opt/jetty/start.jar \
jetty.port=8080 \
etc/jetty-logging.xml \
etc/jetty-started.xml \
etc/jetty-requestlog.xml \
OPTIONS=plus etc/jetty-plus.xml \
--daemon

```

This will replace both `/etc/init.d/jetty` and `/etc/default/jetty`.

If you run `service jetty reload`, it will create a thread dump (like [jstack][4]) in `/var/log/upstart/jetty.log`.

You can even add `respwan` to have the JVM automatically restarted if it unexpectedly quits for some reason.

A similar approach can be used for other JVM based servers, like Apache Tomcat.

 [1]: http://www.eclipse.org/jetty/
 [2]: http://www.eclipse.org/jetty/documentation/current/startup-unix-service.html
 [3]: http://upstart.ubuntu.com/
 [4]: http://docs.oracle.com/javase/8/docs/technotes/tools/unix/jstack.html