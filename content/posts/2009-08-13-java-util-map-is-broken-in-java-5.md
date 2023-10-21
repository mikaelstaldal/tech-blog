---
title: java.util.Map is broken in Java 5
author: Mikael Ståldal
type: post
date: 2009-08-13T14:41:18+00:00
url: /2009/08/13/java-util-map-is-broken-in-java-5/
category:
  - Java

---
Java 5 added [generics][1]. The collection classes was modified to make use generics to provide compile-time type-safe collections. Sadly, this was not done properly.

The worst problem is in the interface `java.util.Map`:

```
public interface Map<K,V> {
    // more methods...

    V get(Object key);
    V remove(Object key);
    boolean containsKey(Object key);
    boolean containsValue(Object key);
}

```

The _key_ parameters to these methods ought to be declared to be _K_ and not _Object_. Now we don&#8217;t get any type-safety for those methods. If you create a `HashMap<String,String>` and then by mistake try to use an int as key when looking up a value, you will not get any compile-time error. Worse yet, you will not even get any run-time error, it will just appear as if there is no value with that key (which in some sense is correct).

This can cause hard to find bugs like this:

```
public class MapTest {
    private Map<String,String> map = new HashMap<String,String>();

    public void setFoo(int i, String s) {
        map.put(String.valueOf(i), s);
    }

    public String getFoo(int i) {
        return map.get(i); // OOPS, should have been String.valueOf(i)
    }
}

```

(Yes, this code is pretty stupid, but it&#8217;s only a simple example.)

There are similar problems in `java.util.Collection` (`contains` and `remove` methods) and some other interfaces, but that&#8217;s less serious since they are not used very often. However, it&#8217;s very serious in `java.util.Map` since you _always_ use the `get` method.

 [1]: http://java.sun.com/javase/6/docs/technotes/guides/language/generics.html