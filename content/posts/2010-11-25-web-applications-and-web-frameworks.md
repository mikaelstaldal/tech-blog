---
title: Web applications and web frameworks
author: Mikael Ståldal
type: post
date: 2010-11-25T15:22:59+00:00
url: /2010/11/25/web-applications-and-web-frameworks/
categories:
  - AJAX
  - web

---
If you are to develop a web application, there are a lot if frameworks to choose between.

I assume that the web application by its nature needs to have bi-directional communication between the web browser and the server during the execution, initial downloading of resources is not enough. I also assume that the available technologies are HTML, CSS and JavaScript/AJAX; no Flash, Java applets, ActiveX, Silverlight or other browser plug-ins are used.

The first thing you should do is to decide what type of web application you want to develop, since that decision have a big impact on what frameworks that are suitable.

The primary question to ask is whether the application logic should be driven from the server or from JavaScript in the web browser. Before we had AJAX, server driven logic was the only possibility, but with AJAX it is also possible with client driven logic. It is also possible to have a mixture, but that should be avoided since it tends to make the application hard to test and lead to messy code design.

With server driven logic, most requests to the server return a complete HTML page. There may also be some AJAX requests which returns HTML fragments.

With client driven logic, only the initial request return a complete HTML page (usually a quite empty page). All subsequent requests are AJAX which return data from the server in JSON or XML format. This makes it possible to implement the server part as a web service which could be used for other things than providing data for the web application. This also makes the server part easy to test separately. (This is usually associated with <cite>Web 2.0</cite>.)

Secondly, the framework choice should also depend on whether you are developing the whole system from scratch, or if you have an existing backend with data persistence that you need a web user interface for. When developing from scratch, you can benefit from using a <cite>full stack</cite> framework with integrated data persistence, but with an existing backend you are probably better off with a framework which only does the web tier.