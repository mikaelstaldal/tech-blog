---
title: 'SQLite backup'
slug: sqlite-backup
author: 'Mikael Ståldal'
type: post
date: 2025-07-14T11:00:00+02:00
year: 2025
month: 2025/07
day: 2025/07/14
category:
  - database
  - SQLite
---

As I [mentioned earlier](/tech/2025/07/12/simple-webapp-with-go/), it's straightforward to
use [SQLite](https://sqlite.org) as the relational database in Go applications. Your data is stored in one single file with a 
[well-defined format](https://sqlite.org/fileformat2.html) and there is no hassle with installing and [configuring](https://sqlite.org/zeroconf.html) 
a separate database.

However, for any serious application you most likely want backup of your data. If your dataset is not very large, and it
is OK to lose updates since the last backup, there is a very simple option. Use the `sqlite3` command line tool:

```bash
rm -f backup_of_your_database.sqlite 
sqlite3 your_database.sqlite "VACUUM INTO 'backup_of_your_database.sqlite'"
```

This command will fail if the backup file already exists, so don't forget to remove or move it first. This will make
a consistent snapshot of the database and is safe to run while your application is using the database. Then you can
set up a cron job to run this every day (or on whatever cadence you like). You can save storage space by compressing
the backup file with `gzip` or similar tool.

If your database is lost or corrupted, stop the application, copy the latest backup file in its place and restart
the application.

More information [here](https://litestream.io/alternatives/cron/).

If your dataset is huge, and you want incremental backups, and/or you don't want to risk losing recent updates, then
this solution might be inadequate. There are other more sophisticated options like [Litestream](https://litestream.io/) 
(although I have not tried that).
