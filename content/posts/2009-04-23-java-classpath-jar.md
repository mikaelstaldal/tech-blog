---
year: 2009
month: 2009/04
day: 2009/04/23
title: 'java -classpath *.jar'
author: Mikael Ståldal
type: post
date: 2009-04-23T11:29:35+00:00
slug: java-classpath-jar
category:
  - Java

---
It&#8217;s quite annoying that you cannot use wildcards in the `-classpath` command line option to `java` and `javac`. Quite often you want to include all `.jar` files in one directory.

Here is a way to get that effect:

> java -classpath \`echo lib/*.jar | sed -e &#8220;s/ /:/g&#8221;\` org.foo.MyApp 

You can even include all `.jar` files in a whole hierarchy of directories:

> java -classpath \`find repository -name *.jar -printf %p:\` org.foo.MyApp 

In general it&#8217;s better to use [Ant][1] or [Maven][2] for compiling and [Java Service Wrapper][3] for running, they have built-in support for wildcards. But they require some upfront setup, so my solution is useful for ad-hoc usage.

This works in Linux and probably in Solaris and other UNIX systems. If you use Windows, you need to install [cygwin][4] or similar.

 [1]: http://ant.apache.org/
 [2]: http://maven.apache.org/
 [3]: http://wrapper.tanukisoftware.org/
 [4]: http://www.cygwin.com/