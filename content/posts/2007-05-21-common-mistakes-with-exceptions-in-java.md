---
year: 2007
month: 2007/05
day: 2007/05/21
title: Common mistakes with exceptions in Java
author: Mikael Ståldal
type: post
date: 2007-05-21T11:33:54+00:00
slug: common-mistakes-with-exceptions-in-java
category:
  - Java

---
### Unintentional catching of runtime exceptions

Unfortunately, checked exceptions in Java are defined as all [Exception][1]s which are not [RuntimeException][2]s. This makes it a bit tricky to catch all checked exceptions (but not any runtime exceptions). It would have been better if checked exceptions were defined by a specific class, `CheckedException`, but that&#8217;s too late to change now.

Too often Java programmers catch all exceptions when they really only should catch checked exceptions. However, there is a quite easy workaround to catch all checked exceptions, and nothing else:

```
try {
  // do something which may throw a checked exception
} catch (RuntimeException e) {
  throw e;
} catch (Exception e) {
  // only checked exceptions are caught here
  // handle the checked exception
}

```

### Framework too restrictive with exceptions on method interfaces

A framework usually contains interfaces (or abstract classes) that the application using the framework should implement. Quite often the only allowed checked exception is a special exception defined by the framework (such as `org.xml.sax.SAXException` or `java.xml.servlet.ServletException`), and the application is expected to catch and wrap all other checked exceptions in this exception. This is usually a bad framework design. A framework usually provides (or should provide) exception and error handling to the application, and the application should be able to just propagate checked exceptions to the framework. In other words, the methods in framework interfaces should be declared to throw Exception. There may of course be exceptions (sic!) to this rule.

It&#8217;s quite silly to have to do:

```
public void doPost(HttpServletRequest request, HttpServletRequest response)
    throws ServletException {
  try {
    // do some JDBC stuff which may throw a SQLException
  } catch (SQLException e) {
    throw new ServletException(e);
  }
}

```

instead of just:

```
public void doPost(HttpServletRequest request, HttpServletRequest response)
    throws SQLException {
  // do some JDBC stuff which may throw a SQLException
}

```

### Excessive exception chaining

From Java 1.4, all exceptions (in fact all throwables) supports chaining, i.e. an exception can contain another exception as its cause. This chaining can also be recursive; an exception can contain an exception which contains an exception, which contains an exception, etc. When a stack trace is generated, it usually contains the whole chain of exceptions.

Exception chaining can be very useful, especially to provide a clean high-level interface to a library and still preserve low-level debugging information. This is described as &#8220;first reason&#8221; [here][3].

However, it is often used ad-hoc to quickly conform to interfaces not allowing you to propagate certain exceptions, as described as &#8220;second reason&#8221; [here][3]. This usually only adds confusion and unnecessary verbosity to error logs. This is usually due to bad framework design, as described above.

### Silently ignoring unexpected exceptions

The worst mistake is to catch and silently ignore unexpected exceptions. When you catch an unexpected exception, always record an error message with a full stack trace somewhere (to the console, to some error log, in a pop-up window or in some other way). An unexpected exception usually indicates that there is a bug somewhere, and it&#8217;s stack trace provides invaluable information for quickly locating and fixing the bug. It&#8217;s not uncommon that a stack trace saves hours of debugging. Exceptions with stack traces is a great tool for debugging, don&#8217;t take it away!

There are some rare cases when it&#8217;s reasonable to ignore a specific exception, one of them is:

```
try {
  Thread.sleep(1000); // sleep for one second
} catch (InterruptedException e) {
  // we can ignore this since we do not 
  // expect this thread to get interrupted
}

```

But **never** catch and ignore Exception, RuntimeException, all checked exceptions, or some other broad class of exceptions. Only catch one very specific exception if you are going to ignore it.

 [1]: http://java.sun.com/javase/6/docs/api/java/lang/Exception.html
 [2]: http://java.sun.com/javase/6/docs/api/java/lang/RuntimeException.html
 [3]: http://java.sun.com/javase/6/docs/api/java/lang/Throwable.html