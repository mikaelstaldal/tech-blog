---
title: Who needs rmiregistry?
author: Mikael Ståldal
type: post
date: 2006-05-11T20:58:39+00:00
url: /2006/05/11/who-needs-rmiregistry/
categories:
  - Java

---
[Java Remote Method Invocation (RMI)][1] contains a tool _[rmiregistry][2]_ to run a stand-alone remote object registry. According to the [RMI tutorial][3], _rmiregistry_ is normally used in an RMI application.

I wonder why. It&#8217;s actually almost as simple to run the remote object registry within the RMI server. You only have to use `java.rmi.registry.LocateRegistry#createRegistry(int port)` method like this:

```
Registry registry = LocateRegistry.createRegistry(port);
registry.bind("Foo", stub);
```

[Here][4] is a complete example.

This is also more efficient since you don&#8217;t have to start a separate JVM for the registry. Running the registry within the RMI server doesn&#8217;t even require an extra thread, the registry is just another remote object.

Does anyone know about any sensible reasons for using _rmiregistry_?

 [1]: http://java.sun.com/products/jdk/rmi/
 [2]: http://java.sun.com/j2se/1.4.2/docs/tooldocs/windows/rmiregistry.html
 [3]: http://java.sun.com/j2se/1.4.2/docs/guide/rmi/getstart.doc.html
 [4]: http://www.staldal.nu/tech/files/rmitest.zip