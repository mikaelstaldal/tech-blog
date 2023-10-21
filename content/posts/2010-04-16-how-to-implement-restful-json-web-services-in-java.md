---
title: How to implement RESTful JSON Web Services in Java
author: Mikael Ståldal
type: post
date: 2010-04-16T12:49:29+00:00
url: /2010/04/16/how-to-implement-restful-json-web-services-in-java/
category:
  - AJAX
  - Java
  - JavaEE
  - web

---
You can implement [RESTful][1] Web Services in Java using the [JAX-RS][2] framework.

JAX-RS is part of the [JavaEE][3] 6 platform. But if you are not using a JavaEE 6 application server, you can use the reference implementation [Jersey][4] and embed it in any web application server.

However, it&#8217;s quite awkward to produce [JSON][5] output from Jersey.

Jersey has some support for [producing JSON via JAXB][6], but to get the `NATURAL` encoding (which you probably want) you need JAXB 2.1. And that can be problematic since JAXB 2.0 is bundled with JavaSE 6 and with some application servers (such as WebLogic). Overriding that with a later version of JAXB can be really difficult. Using JAXB is also a bit clumsy if you only want to produce JSON.

And using the [low-level JSON support][7] in Jersey is not fun at all.

The solution is to use [Jackson][8] and refer to its JAX-RS integration package `org.codehaus.jackson.jaxrs` in Jerseys `com.sun.jersey.config.property.packages` parameter (remember to separate several packages with semicolon ; ).

Then just return POJO:s from your JAX-RS resource classes.

You need these dependencies:

```
<dependency>
		<groupId>com.sun.jersey</groupId>
		<artifactId>jersey-core</artifactId>
		<version>1.1.4.1</version>
	</dependency>
	<dependency>
		<groupId>org.codehaus.jackson</groupId>
		<artifactId>jackson-core-asl</artifactId>
		<version>1.2.1</version>
	</dependency>
	<dependency>
		<groupId>org.codehaus.jackson</groupId>
		<artifactId>jackson-mapper-asl</artifactId>
		<version>1.2.1</version>
	</dependency>
	        <dependency>
	        <groupId>org.codehaus.jackson</groupId>
	        <artifactId>jackson-jaxrs</artifactId>
	        <version>1.2.1</version>
	</dependency>

```

 [1]: http://en.wikipedia.org/wiki/RESTful
 [2]: http://jcp.org/en/jsr/detail?id=311
 [3]: http://java.sun.com/javaee/
 [4]: https://jersey.dev.java.net/
 [5]: http://json.org/
 [6]: https://jersey.dev.java.net/nonav/documentation/latest/user-guide.html#d4e792
 [7]: https://jersey.dev.java.net/nonav/documentation/latest/user-guide.html#d4e995
 [8]: http://jackson.codehaus.org/