---
title: How to design a RESTful protocol
author: Mikael Ståldal
type: post
date: 2012-08-24T08:40:57+00:00
slug: how-to-design-a-restful-protocol
category:
  - web

---
## What is REST?

In most cases, it is sufficient say that [REST][1] is a way to design a network protocol based on HTTP. I perfer to call it a _RESTful protocol_, but it can also be called _RESTful API_ or _RESTful Web Service_. It is important to keep in mind that it technically is a network protocol, and not an API like an interface with some methods in a regular programming language.

REST is not [RPC][2] or [RMI][3]. You should not try to map an existing API in a regular programming language to a RESTful protocol directly method by method. Rather, you should map the [domain model][4] of your application to the protocol.

REST is not a religion. Be pragmatic and use what works for you. But be sure to understand the rules before you possibly break them, otherwise you may get unpleasant surprises.

## How to do REST

The most important rule is to use [HTTP][5] properly and leverage it extensively. Read and understand the HTTP 1.1 specification in [RFC2616][6].

Understand the concept of _safe_ and _idempotent_ methods:

  * safe &#8211; no observable side-effects
  * idempotent &#8211; doing same request several times have the same effect as doing it once

And use the appropriate HTTP methods:

  * GET and HEAD are safe and idempotent
  * PUT and DELETE are not safe but idempotent
  * POST does not have to be either safe or idempotent

Utilize the rich set of response codes defined in HTTP:

  * 200 OK
  * 201 Created
  * 202 Accepted
  * 303 See Other
  * 304 Not Modified
  * 400 Bad Request
  * 401 Unauthorized
  * 403 Forbidden
  * 404 Not Found
  * 405 Method Not Allowed
  * 406 Not Acceptable
  * 409 Conflict
  * 412 Precondition Failed
  * 415 Unsupported Media Type
  * 500 Internal Server Error
  * 503 Service Unavailable

Make use of HTTP headers:

  * Location
  * Allow
  * Authorization, WWW-Authenticate
  * Content-Type, Accept
  * ETag, If-Match, If-None-Match
  * Last-Modified, If-Modified-Since, If-Unmodified-Since
  * Cache-Control
  * _etc_

The request and response messages should simply contain your domain objects, probably encoded as JSON or XML (do not forget to set proper Content-Type). Do not wrap it in any envelope as SOAP does.

Do this: `{"prop1":"foo","prop2":["one","two","three"]}`

Do not do this: `{"result":{"prop1":"foo","prop2":["one","two","three"]}}`

Use HTTP response codes for errors/exceptions.

### State and security

Try to avoid storing client session state on the server. You can push small session state to the client in URLs. Use HTTP Authentication, possibly with [OAuth][7], to avoid having to keep track of &#8220;logged in users&#8221; on the server. Always use HTTPS with proper server certificates if you have any authentication, and consider using client certificates if it makes sense.

### HATEOAS

If you follow all advices so far, you will probably be able to design a good and useful protocol. But it will not be RESTful unless you also apply [Hypermedia as the Engine of Application State][8].

This will give you a high degree of decoupling between client and server. It will be easy to evolve the protocol in a backwards compatible way, to allow newer clients make use of new features and still allow old clients to operate. And you can do this without any explicit versioning of the protocol.

The client should only need one entry-point URL, and will get all other URLs in responses from the server.

In HTML, you have semi-standardized link relations:  
`<link href="http://foo.com/bar/edit" rel="edit" />`

Use something similar to allow the server to send back URLs to the client:  
`{"links":{"edit":"http://foo.com/1/edit","next":"http://foo.com/2"}}`

URLs should be opaque to the client. The client should accept both absolute and relative URLs, and resolve relative URLs according to [RFC3986][9] (use a platform or 3rd party library for this). The client may sometimes append query parameters. The client should never inspect or manipulate URLs in any other way. (This is exactly how an ordinary web browser handles links in an HTML web page.)

 [1]: http://en.wikipedia.org/wiki/REST
 [2]: http://en.wikipedia.org/wiki/Remote_procedure_call
 [3]: http://en.wikipedia.org/wiki/Java_remote_method_invocation
 [4]: http://en.wikipedia.org/wiki/Domain_model
 [5]: http://en.wikipedia.org/wiki/Http
 [6]: http://tools.ietf.org/html/rfc2616
 [7]: http://en.wikipedia.org/wiki/OAuth
 [8]: http://en.wikipedia.org/wiki/HATEOAS
 [9]: http://www.ietf.org/rfc/rfc3986.txt