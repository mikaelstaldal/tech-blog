---
year: 2014
month: 2014/03
day: 2014/03/04
title: Don’t use PipedOutputStream on Android
author: Mikael Ståldal
type: post
date: 2014-03-04T11:08:16+00:00
slug: dont-use-pipedoutputstream-on-android
category:
  - Android
  - Java

---
I was using `java.io.PipedOutputStream` in an Android app. The app performed horribly bad. After doing some profiling, it turned out that the call to `PipedOutputStream.write(byte[])` that was really slow. After digging into the Android source code, I discovered that `PipedOutputStream.write(byte[])` was not implemented, it just delegated to the default implementation in `OutputStream` which iterate through the array and call `PipedOutputStream.write(byte)` for each byte.

Since `PipedOutputStream.write(byte)` does some synchronization and `Object.notifyAll()` each time, it is really slow to do this 1000 times when you write a block of 1 KB data.

Just out of curiosity, I had a look on how `PipedOutputStream` is implemented in Oracle&#8217;s standard Java implementation. I haven&#8217;t actually done any benchmarks on it, but I can see from the source code that it is a completely different implementation which does implement writing a block properly and probably efficiently.

The bottom line is: Don&#8217;t use `PipedOutputStream` on Android. If you need similar functionality, implement it yourself or find a 3rd party library which does it.