---
year: 2014
month: 2014/06
day: 2014/06/05
title: Don’t use large BLOBs in MySQL from Java
author: Mikael Ståldal
type: post
date: 2014-06-05T13:55:50+00:00
slug: dont-use-large-blobs-in-mysql-from-java
category:
  - database
  - Java

---
The MySQL database can store large chunks of binary data (up to 1 GB) using the [BLOB data types][1].

However, this does not work well if you access the MySQL database from Java (or any other JVM based language) using the [MySQL JDBC driver][2]. 

The JDBC API supports an efficient stream based way to handle BLOBs, but the MySQL JDBC driver does not implement this properly. It works, but it will buffer all data in memory in a way which is very inefficient and can make your JVM run out of memory if the BLOBs are large.

A good rule of thumb is to not store any objects larger than 64 KB in MySQL. Store such objects as files outside of the database instead. So never use the MEDIUMBLOB, LONGBLOB, MEDIUMTEXT or LONGTEXT data types.

(I am not sure whether this advise is only valid for JVM, or for usage of MySQL from other environments as well.)

 [1]: http://dev.mysql.com/doc/refman/5.7/en/blob.html
 [2]: http://dev.mysql.com/doc/connector-j/en/index.html