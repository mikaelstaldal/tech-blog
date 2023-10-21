---
title: Typesafe’s Reactive Straw man
author: Mikael Ståldal
type: post
date: 2015-08-03T12:28:22+00:00
url: /2015/08/03/typesafes-reactive-straw-man/
category:
  - Java
  - Linux
  - reactive

---
In their quest to promote [Reactive][1], [Typesafe][2] is beating up a [straw man][3] by portraying blocking I/O in a particularly stupid way which is rarely (if ever) done in practice.

In a [recent webinar][4], I found [this slide][5] which suggests that a blocking I/O operation will waste CPU time while waiting for the I/O to complete.

If I understand it correctly, it does not actually work like this in any reasonable runtime environment / operating system. As an example, consider doing [java.io.InputStream.read()][6] on a socket in Java (or any other language on the JVM) on Linux. If there is not data available in the buffer, this call will block until some packet is received by the network interface, which may take several seconds. During that time, the JVM [Thread][7] is blocked, but the JVM and/or Linux kernel will reschedule the CPU core to another thread or process and will wait for the network interface to issue an interrupt when some packet is received. You will waste some time on thread scheduling overhead and user/kernel mode switching, but that&#8217;s typically much less than the I/O waiting time.

I am quite sure it will work the same way on other runtime environments (such as .Net) and operating systems (such as Microsoft Windows, Solaris, Mac OS X).

There are other reasons why blocking I/O can be problematic, and the Reactive principles are useful in many cases. But please be honest and don&#8217;t portray blocking I/O worse than it actually is.

 [1]: http://www.reactivemanifesto.org/
 [2]: http://www.typesafe.com/
 [3]: https://en.wikipedia.org/wiki/Straw_man
 [4]: http://www.typesafe.com/resources/video/reactive-revealed-13-async-nio-back-pressure-and-message-driven-vs-event-driven
 [5]: http://image.slidesharecdn.com/reactiverevealedp1-asyncnioback-pressureandmessagevsevent-driven-150730173340-lva1-app6892/95/reactive-revealed-p1-async-nio-backpressure-and-message-vs-eventdriven-46-638.jpg?cb=1438277844
 [6]: http://docs.oracle.com/javase/7/docs/api/java/io/InputStream.html#read()
 [7]: http://docs.oracle.com/javase/7/docs/api/java/lang/Thread.html