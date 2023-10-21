---
title: Web application frameworks in Java
author: Mikael Ståldal
type: post
date: 2010-11-25T15:56:58+00:00
url: /2010/11/25/web-application-frameworks-in-java/
categories:
  - AJAX
  - Java
  - JavaEE
  - web

---
When you know [which type of web application you are to develop][1], it&#8217;s time to have a look at some possible choices.

I have tried to categorize some modern and popular web application frameworks in Java.

## Simple server driven MVC page based

This category contains the traditional frameworks used for developing web applications with purely server driven application logic. They are based on complete HTML pages and uses the [Model-View-Controller][2] design pattern.

They do not directly support for client driven application logic, though it can be done if combined with a comprehensive JavaScript library like [jQuery][3].

  * [Spring Web MVC][4]
  * [Struts 2.2][5]
  * [Stripes][6]

## Full stack server driven MVC page based

This category contains some more advanced <cite>full stack</cite> frameworks. They are used for server driven application logic and not suitable for client driven application logic. They are inspired by [Ruby on Rails][7].

  * [Play][8] 
  * [Grails][9] (using [Groovy][10])

## Server driven component/widget based

Focus on UI components (widgets) instead of HTML pages, make development a bit more like desktop applications in frameworks like Swing. They are used for server driver application logic and not suitable for client driven application logic.

  * [JavaServer Faces][11]
  * [Wicket][12]
  * [Tapestry][13]
  * [Click][14]

## Client driven component/widget based

Useful for developing client driven application logic by automatically generating the client side JavaScript code. 

  * [Google Web Toolkit][15]
Compiles Java to JavaScript and handle the cross-browser issues. Also abstracts away most of HTML. There is a good [tutorial][16].

  * [Vaadin][17]
Based on GWT, but abstracts away even more HTML. Also handle the server side and automates AJAX based browser-server communication (using a native data format). A programming model which feels much more like Swing than usual web application development.

  * [AribaWeb][18]
Quite advanced full stack framework.

 [1]: http://www.staldal.nu/tech/2010/11/25/web-applications-and-web-frameworks/
 [2]: http://en.wikipedia.org/wiki/Model-View-Controller
 [3]: http://jquery.org/
 [4]: http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/html/mvc.html
 [5]: http://struts.apache.org/
 [6]: http://www.stripesframework.org/
 [7]: http://en.wikipedia.org/wiki/Ruby_on_Rails
 [8]: http://www.playframework.org/
 [9]: http://www.grails.org/
 [10]: http://groovy.codehaus.org/
 [11]: http://www.oracle.com/technetwork/java/javaee/javaserverfaces-139869.html
 [12]: http://wicket.apache.org/
 [13]: http://tapestry.apache.org/tapestry5/
 [14]: http://click.apache.org/
 [15]: http://code.google.com/intl/sv/webtoolkit/
 [16]: http://code.google.com/intl/sv/webtoolkit/doc/latest/tutorial/index.html
 [17]: http://vaadin.com/home
 [18]: http://aribaweb.org/