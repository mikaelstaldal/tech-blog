---
year: 2008
month: 2008/12
day: 2008/12/16
title: Configure web applications in JBoss
author: Mikael Ståldal
type: post
date: 2008-12-16T13:58:32+00:00
slug: configure-web-applications-in-jboss
category:
  - Java
  - JavaEE

---
When you deploy a web application in a [JavaEE][1] application server, it usually consist of a `.war` archive. 

Sometimes, the web application needs some configuration parameters. The most common way to do this is to have `<context-param>` in `web.xml`. That is simple and works fine except that the `web.xml` file needs to be inside the `.war` archive. This makes it inconvenient to change a configuration parameter since you have to repack the `.war` archive. You also have to set the same value several times if several web applications share the same configuration.

It would be nice to be able to specify the configuration parameter values outside the `.war` archive, in a way so that several web applications in the same application server can use the same parameter value. Sadly, the [JavaEE][1] specification offers no simple way to do this portably.

However, I found a way to do it in [JBoss][2] 4.2.2. Create a file named `something-service.xml` in the JBoss deployment directory with the following structure:

```
<server>
<mbean code="org.jboss.naming.JNDIBindingServiceMgr"
       name="pm-urls:service=JNDIBindingServiceMgr">
    <attribute name="BindingsConfig" serialDataType="jbxb">
    <jndi:bindings
        xmlns:xs="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:jndi="urn:jboss:jndi-binding-service:1.0"
        xs:schemaLocation="urn:jboss:jndi-binding-service:1.0 resource:jndi-binding-service_1_0.xsd">
    <jndi:binding name="myapp/BackendHost"><jndi:value>somehost</jndi:value></jndi:binding>
    <jndi:binding name="myapp/BackendPort"><jndi:value type="java.lang.Integer">4711</jndi:value></jndi:binding>
    </jndi:bindings>
    </attribute>
    <depends>jboss:service=Naming</depends>
</mbean>
</server> 

```

Then lookup the configuration parameters using JNDI in the web application(s):

```
InitialContext initCtx = new InitialContext();
String backendHost = (String)initCtx.lookup("myapp/BackendHost");
int backendPort = (Integer)initCtx.lookup("myapp/BackendPort");
```

Se some [documentation][3] about this.

 [1]: http://java.sun.com/javaee/
 [2]: http://www.jboss.org/
 [3]: http://www.redhat.com/docs/manuals/jboss/jboss-eap-4.2/doc/Server_Configuration_Guide/Additional_Naming_MBeans-JNDI_Binding_Manager.html