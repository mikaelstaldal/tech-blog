---
title: Objects vs. data structures
author: Mikael Ståldal
type: post
date: 2016-02-08T21:45:21+00:00
url: /2016/02/08/objects-vs-data-structures/
categories:
  - Java
  - programming

---
Several popular statically typed programming languages, including C++, Java and C#, have a serious design flaw. They make no useful distinction between objects in the <a href="https://en.wikipedia.org/wiki/Object-oriented_programming" target="_blank" rel="noopener">OOP</a> sense and plain data structures.

A plain data structure should only be a dumb container for data. It should not have any behaviour, only simple accessors for data items in it. It should not be possible to override data accessors. It should be clear and transparent what it does.

Good old C has a working construct for plain data structures, the `struct`. 

C++, even though trying to be compatible with C, managed to mess it up. C++ added `class` for OOP objects, but also extended `struct` to be more or less equivalent to `class`. Even though there seems to be a convention in C++ to use `struct` for plain data structures and `class` for OOP objects, there is no guarantee that a `struct` in fact is just a plain data structure without surprising behaviour.

Java made it worse by skipping `struct` completely and providing no other construct for plain data structures than `class` which is primarily made for OOP objects. In the Java community, there is no general convention for making any distinction. To make things even worse, the horribly verbose <a href="http://docs.oracle.com/javase/tutorial/javabeans/" target="_blank" rel="noopener">Java Beans convention</a> is quite popular and has support in the standard library.

C# actually have a meaningful difference between `struct` and `class`, making `struct` more suitable for plain data structures. However, it seems like `struct` have too much OOP like functionality built in and that it is possible to provide surprising behaviour.

<a href="http://www.scala-lang.org/" target="_blank" rel="noopener">Scala</a> has `class` for OOP objects, but does also provide <a href="http://www.scala-lang.org/files/archive/spec/2.11/05-classes-and-objects.html#case-classes" target="_blank" rel="noopener">case classes</a> which are suitable for plain data structures. Case classes also have some bonus features like pattern matching and auto generated methods for equality, hash code and string representation. Together with Scala language features like named parameters and immutability by default, they work reasonably well as plain data structures. However, I wish they could be more restrictive and not allow OOP features like general inheritance (which does not work well for case classes anyway) and overriding accessors.

It is possible to use <a href="https://en.wikipedia.org/wiki/Associative_array" target="_blank" rel="noopener">associative arrays</a> as data structures, and then you get no surprising behaviour. This is popular in Javascript which have nice syntax for this. However, most other languages do not have a convenient syntax for this, and in particular it does not work well in a statically typed language. I like to declare my data structures, and it should not be possible to add arbitrary values to instances of them at runtime. Associative arrays usually also have a runtime performance overhead.

It is also possible to use tuples (which some languages have) as data structures, but I want the items in them to be named, not ordered.

Is my only choice to use C?

_Updated: mentioned that it is about statically typed languages_

_Update: Java finally fixed this by adding [`record`.][1]_

 [1]: https://blogs.oracle.com/javamagazine/post/records-come-to-java