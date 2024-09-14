---
title: 'No streaming with pgJDBC'
slug: no-streaming-with-pgjdbc
author: 'Mikael Ståldal'
type: post
date: 2024-09-14T17:18:49+02:00
year: 2024
month: 2024/09
day: 2024/09/14
category:
  - Java
  - database

---

I am using [PostgreSQL](https://www.postgresql.org/) from a Kotlin (JVM) application with
the [pgJDBC driver](https://jdbc.postgresql.org/).

According to the documentation, you
can [get results from a query based on a cursor](https://jdbc.postgresql.org/documentation/query/#getting-results-based-on-a-cursor)
to avoid loading the whole result set into the application's memory at once by calling the `setFetchSize()` method with
a positive value on the `Statement` before issuing the query.

I had a non-trivial query which generated a lot of rows (several thousands), and I only needed the first hundred or so.
So I hoped I could activate the cursor, iterate through the result set until I had got all the data I needed and then
close it long before reaching the end.

Strictly speaking, this works as documented. Closing the result set half-way through is valid and doesn't break
anything, you avoid loading the rest of rows into application memory, and you save network traffic between application
and database. Activating the cursor gave a small but measurable performance boost.

However, the performance was still very disappointing, and it did not at all do what I (perhaps naively) expected.
I did some profiling, and it took a long time (a few seconds) before the first row was received by the application, and
after that I got the rest in 20 milliseconds or so. Considering that you usually have very good and cheap bandwidth
between application and database (they are likely running in the same data center, or even on the same machine), saving
bandwidth there is not very important.

I was expecting the database to be able to execute the query incrementally and start streaming the result to the
application before fully finished, but apparently it cannot do that. I am not sure if this is a limitation in the pgJDBC
driver or in PostgreSQL itself, and I have not tried with any other relational database.

So lesson learned: make sure to write your SQL query carefully to only return the rows you need, by
using [WHERE](https://www.postgresql.org/docs/16/queries-table-expressions.html#QUERIES-WHERE) and/or
[LIMIT](https://www.postgresql.org/docs/16/queries-limit.html). Luckily, you can do this in
a [subquery](https://www.postgresql.org/docs/16/queries-table-expressions.html#QUERIES-SUBQUERIES) or
a [CTE](https://www.postgresql.org/docs/16/queries-with.html), not only on the whole result.
