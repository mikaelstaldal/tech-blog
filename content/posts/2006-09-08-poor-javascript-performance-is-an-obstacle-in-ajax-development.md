---
title: Poor Javascript performance is an obstacle in AJAX development
author: Mikael Ståldal
type: post
date: 2006-09-08T09:27:57+00:00
slug: poor-javascript-performance-is-an-obstacle-in-ajax-development
category:
  - AJAX
  - web

---
I&#8217;m currently developing my first [AJAX][1] based web application. The goal is to have a pure AJAX application, i.e. never reload the entire page, use only background XMLHTTPRequest to contact the server.

My observations so far is that it is possible to do most of the application logic I need. But the performance of Javascript execution in the browser is a big obstacle. The application is centered around a list of data items in a scrollable area. The list is loaded as preformatted XHTML with an AJAX request and then some Javascript is used to decorate it with event handlers. I would like to display up to 1000 items at once, but I quickly realized that this wasn&#8217;t possible. The Javascript loop triggered the timeout in the browser after about five seconds. This timeout does not count waiting for the server to deliver the response, it only counts the client Javascript code to process the response. This timeout is reasonable, it&#8217;s clearly not acceptable for the user to wait over five seconds for the browser to process the server response (in addition to wait for the server and network to deliver the response). After limiting to 100 item, it works.

To make it feasible to build pure AJAX web applications working with lots of data, the performance of Javascript execution in the web browsers needs to improve drastically. In particular, iterating over large collections must be much faster. I think that a way to acheive this would be to use [Just-in-time compilation][2] of the Javascript code, similar to what modern [JVM][3]:s does.

The web browser I use is Mozilla Firefox in Linux.

 [1]: http://en.wikipedia.org/wiki/Ajax_%28programming%29
 [2]: http://en.wikipedia.org/wiki/Just-in-time_compilation
 [3]: http://en.wikipedia.org/wiki/JVM