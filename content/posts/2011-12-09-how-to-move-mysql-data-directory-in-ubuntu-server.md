---
title: How to move MySQL data directory in Ubuntu Server
author: Mikael Ståldal
type: post
date: 2011-12-09T10:45:00+00:00
url: /2011/12/09/how-to-move-mysql-data-directory-in-ubuntu-server/
category:
  - Linux

---
By default, the MySQL data is placed in `/var/lib/mysql`, which is a reasonable default. However, sometimes you want to place it somewhere else, such as on an other file system. Using a symlink doesn&#8217;t seem to work, so you have follow this procedure.

To move the MySQL data directory from `/var/lib` to `/mnt/mydata`, run these commands as root:

  1. `apt-get install mysql-server`
  2. `service mysql stop`
  3. `mv /var/lib/mysql /mnt/mydata/`
  4. replace `/var/lib/mysql` with `/mnt/mydata/mysql` in 
      * `/etc/passwd` &#8211; mysql
      * `/etc/mysql/my.cnf` &#8211; [mysqld] datadir
      * `/etc/apparmor.d/usr.sbin.mysqld` (twice)
  5. `service mysql start`