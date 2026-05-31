---
title: 'Remote SQLite backup'
slug: remote-sqlite-backup
author: 'Mikael Ståldal'
type: post
date: 2026-05-31T20:00:00+02:00
year: 2026
month: 2026/05
day: 2026/05/31
category:
  - database
  - SQLite
---

I [wrote earlier](/tech/2025/07/14/sqlite-backup/) about how to backup a small SQLite database.

That solution works well for small databases, but can become impractical for larger databases. In particular if the
machine with the database has not enough disk space for another copy of it, and you want to backup to another machine.

One option is to use [sqlite3_rsync](https://sqlite.org/rsync.html), but I could not get that to work, it kept running 
out of memory. So I found another way, [dump the database to text](https://sqlite.org/cli.html#converting_an_entire_database_to_a_text_file) 
and gzip it. Combined with ssh, you can make a backup to a remote machine without storing anything extra on disk on the 
database machine. Run this on the machine where you want to have the backup:

```bash
ssh user@database.machine.com "sqlite3 path/to/mydb.sqlite .dump | gzip" > backups/db.sql.gz
```

Most likely, you can also initiate the backup from the database machine, but I leave that as an exercise to the reader.

(You might think that you could use VACUUM INTO in a similar fashion, but that does not work since it requires random 
access to the target file, you cannot stream it.)
