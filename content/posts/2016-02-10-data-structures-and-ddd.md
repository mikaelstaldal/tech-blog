---
title: Data structures and Domain Driven Design
author: Mikael Ståldal
type: post
date: 2016-02-10T21:01:37+00:00
url: /2016/02/10/data-structures-and-ddd/
categories:
  - programming

---
After listening to a presentation about [Domain Driven Security][1], I got some additional insights about what a [data structure (as opposed to OOP object)][2] should be able to do. Data structures (I call them `struct`) should have a subset of [OOP][3] features which I think is useful and harmless.

A `struct` should allow constructors. Such constructors can have two purposes, to convert one type of data into another and to validate the input. Such constructors should take parameters and be able to throw an exception if the input is invalid, to make it impossible to create an invalid instance of a `struct`. Each constructor should be required to set every field of the `struct`, and if no constructors are defined, a default one should be generated which simply takes all fields as parameters.

It can also be useful to have _derived fields_, which would be a parameter-less function which returns a value computed from one or more fields in the `struct`. They should be pure functions from the current state of the `struct`.

There should be encapsulation so that fields can be marked as `public` or `private`. Which one should be default?

`struct`s should be immutable by default, with an option to mark individual fields of them `mutable`. However, it should be required to mark the whole `struct` as `mutable` to be able to mark any field of it `mutable`. A mutable field cannot be private and it&#8217;s value can be set from outside (typically with assignment syntax).

`struct`s should not have any inheritance or polymorphism, and should not have any methods.

`struct`s should be value types without identity, like a `struct` in C# or a primitive type in Java.

 [1]: http://dearjunior.blogspot.se/search/label/domain%20driven%20security
 [2]: https://www.staldal.nu/tech/2016/02/08/objects-vs-data-structures/
 [3]: https://en.wikipedia.org/wiki/Object-oriented_programming