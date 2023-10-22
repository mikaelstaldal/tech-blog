---
year: 2009
month: 2009/04
day: 2009/04/23
title: Type safe JSP and JSTL
author: Mikael Ståldal
type: post
date: 2009-04-23T16:15:06+00:00
slug: type-safe-jsp-and-jstl
category:
  - Java
  - JavaEE
  - web

---
When using [JavaServer Pages][1], you want to use [JSTL][2] to be able to to flow-control (iterations and conditionals) in a reasonable way. And the recommended way to use JSTL is to use the [Expression Language (EL)][3].

However, using EL is not a good idea at all. Contrary to Java and plain JSP, EL lacks static typing. This means that many errors which the compiler can catch is not detected until runtime when using EL. And even worse, EL doesn&#8217;t even do proper type checking at runtime. In many cases you just end up with an empty string when it in fact is a type error.

Proponents of dynamic languages usually say that static typing is not necessary since you should have automated testing of your code anyway, and that will catch any errors. However, automated testing of web pages is difficult and awkward. And reasonable dynamic languages (such as Python and Ruby) at least do type checking at runtime and generate a visible runtime error.

Fortunately, there is a feature of JSTL called <cite>rtexpvalue</cite> which makes it possible to use JSTL without EL and keep the static typing.

First you have to use alternative versions of the JSTL tag libraries:

```
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jstl/xml_rt" prefix="x" %>
<%@ taglib uri="http://java.sun.com/jstl/sql_rt" prefix="sql" %>

```

Then you use plain JSP expressions instead of EL:

```
<jsp:useBean scope="request" id="fuits" class="java.util.List"/>
<jsp:useBean scope="request" id="foo" class="com.acme.Foo"/>

<c:if test="<%= foo.isBar() %>">
	<p>Foo is bar since <fmt:formatDate type="time" value="<%= foo.getDate() %>"/></p>
</c:if>
<c:forEach items="<%= fruits %>" var="fruit">
	  <jsp:useBean id="fruit" class="com.acme.model.Fruit"/>
	      <tr>
	        <td><%= fruit.getColor() %></td>
	        <td><%= fruit.getTaste() %></td>
              </tr>
</c:forEach>

```

As you see, you have to declare the variables using `<jsp:useBean>`. 

This makes the syntax a bit more clumsy, but that&#8217;s a price worth to pay to get the static typing.

To get the full benefit of the static typing, you should compile all your JSP pages offline before deploying the web application. The best way to do this is to integrate JSP compilation in your build process so that JSP pages is compiled at the same time as your regular Java code is compiled. If you use [Maven][4], you can use [this plugin][5].

 [1]: http://java.sun.com/products/jsp/
 [2]: http://java.sun.com/products/jsp/jstl/
 [3]: http://java.sun.com/products/jsp/reference/techart/unifiedEL.html
 [4]: http://maven.apache.org/
 [5]: http://mojo.codehaus.org/jspc-maven-plugin/