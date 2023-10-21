---
title: In-memory database for testing
author: Mikael Ståldal
type: post
date: 2023-05-01T15:54:58+00:00
url: /2023/05/01/in-memory-database-for-testing/
categories:
  - database
  - Docker
  - Linux

---
I [have written][1] about using an embedded database like [HSQLDB][2] or [H2][3] for testing Java applications. This can still be useful (although JavaEE is not so popular any longer). But even though H2 claims to emulate PostgreSQL and several other popular production SQL databases, sometimes your application uses very specific features of a particular database and you need to test against the real thing to be really sure your application works correctly.

This can conveniently be done using [Testcontainers][4], which run an instance of the real database in a Docker container for your tests. The downside is that this can be significantly slower than an embedded in-memory database like HSQLDB or H2.

However, you can speed it up by making sure that the database store its data in memory. Some databases, such as PostgreSQL, does not support this directly, but I learned a neat trick from a college of mine to do it anyway: use Docker&#8217;s [tmpfs mount][5] option. 

You can do it like this for PostgreSQL:

```
docker run --tmpfs=/pgtmpfs -e PGDATA=/pgtmpfs postgres
```

or like this with Testcontainers: 

```
new PostgreSQLContainer<>(PostgreSQLTestImages.POSTGRES_TEST_IMAGE).withTmpFs(Map.of("/pgtmpfs", "rw")).addEnv("PGDATA", "/pgtmpfs")
```

 [1]: https://www.staldal.nu/tech/2013/10/13/using-an-embedded-sql-database-in-java-web-application/
 [2]: https://hsqldb.org/
 [3]: https://h2database.com/html/main.html
 [4]: https://www.testcontainers.org/modules/databases/
 [5]: https://docs.docker.com/storage/tmpfs/