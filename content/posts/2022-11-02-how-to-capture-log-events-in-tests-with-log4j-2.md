---
year: 2022
month: 2022/11
day: 2022/11/02
title: How to capture log events in tests with Log4j 2
author: Mikael Ståldal
type: post
date: 2022-11-02T19:25:20+00:00
slug: how-to-capture-log-events-in-tests-with-log4j-2
category:
  - Java

---
Sometimes you want to verify that your program actually logs what it is supposed to be logging.

When using [Apache Log4j 2][1] as logging framework, it can be done like this:

  1. Include this dependency (for Maven, adjust appropriately for other build systems): 
```
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <type>test-jar</type>
    <scope>test</scope>
</dependency>

```

  2. Import some stuff: 
```
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.test.appender.ListAppender;

```

  3. Add a `ListAppender` to the logger you are interested in: 
```
var loggerContext = LoggerContext.getContext(false);
var logger = (Logger) loggerContext.getLogger(MyClass.class);
var appender = new ListAppender("List");
appender.start();
loggerContext.getConfiguration().addLoggerAppender(logger, appender);

```

  4. Exercise your code which should be logging.
  5. Extract what was logged: 
```
List<String> loggedStrings = 
        appender.getEvents().stream().map(event -> event.getMessage().toString()).collect(Collectors.toList());

```

**Update:**

Starting with Log4j 2.20.0, this has changed to

```
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core-test</artifactId>
    <scope>test</scope>
</dependency>

```

and

```
import org.apache.logging.log4j.core.test.appender.ListAppender;

```

 [1]: https://logging.apache.org/log4j/2.x/index.html