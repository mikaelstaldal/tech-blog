---
title: Misuse of HTTP GET is a cardinal sin
author: Mikael Ståldal
type: post
date: 2009-07-17T15:49:13+00:00
url: /2009/07/17/misuse-of-http-get-is-a-cardinal-sin/
category:
  - web

---
According to the [RESTful style][1], you should make use of the four HTTP methods GET, POST, PUT and DELETE. However, in many cases only GET and POST is used, and POST is used when you really should use PUT or DELETE. I consider this as a quite minor issue.

However, using GET instead of POST (or PUT or DELETE) is much worse.

The current [HTTP 1.1 specfication (RFC-2616)][2] clearly states that a GET request must be _safe_, i.e. not have any significant side-effect on the server. So in order to change anything on the server, you must use POST (or PUT or DELETE). The older [HTTP 1.0 specification (RFC-1945)][3] from 1996 said the same.

This is important because the HTTP protocol supports caching, both in the client and in intermediate proxies. This caching may result in that GET requests will not get through to the server all the time. If you use GET to perform some action on the server, it will not work reliably unless you do ugly workarounds to circumvent the caching.

Public specifications of the HTTP protocol has made this clear for more than 12 years now. Misuse of the GET method in a web application, web service or any other application of HTTP is a **cardinal sin**.

 [1]: http://en.wikipedia.org/wiki/RESTful
 [2]: http://www.rfc-editor.org/rfc/rfc2616.txt
 [3]: http://www.rfc-editor.org/rfc/rfc1945.txt