---
title: Implementing POX Web Services with Spring WS and JAXB
author: Mikael Ståldal
type: post
date: 2010-04-29T16:37:18+00:00
url: /2010/04/29/implementing-pox-web-services-with-spring-ws-and-jaxb/
categories:
  - Java

---
[Spring Web Services][1] together with [JAXB 2.0][2] provides a convenient way to implement POX Web Services in Java.

POX means <cite>Plain Old XML</cite>, and a POX Web Service is a protocol based on sending XML over HTTP without using any well-known protocol framework like [SOAP][3] or [XML-RPC][4].

First you have to define annotated JAXB classes for all XML request and response messages. If you have a schema, you can generate them with the [`xjc` tool][5]. Or you can create and annotate them manually. It can be a good idea to make one abstract base class for all requests, and one for all responses.

Then create a `WEB-INF/spring-ws-servlet.xml` file:

```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:oxm="http://www.springframework.org/schema/oxm"
	xsi:schemaLocation="
      http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
      http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-2.5.xsd
      http://www.springframework.org/schema/oxm http://www.springframework.org/schema/oxm/spring-oxm-1.5.xsd">

	<context:annotation-config />
	<context:component-scan base-package="com.acme.coolservice" />

        <oxm:jaxb2-marshaller id="marshaller" contextPath="com.acme.coolservice.jaxb" />		
	<bean class="org.springframework.ws.server.endpoint.mapping.PayloadRootAnnotationMethodEndpointMapping" />
	<bean id="messageFactory" class="org.springframework.ws.pox.dom.DomPoxMessageFactory" />
	<bean class="org.springframework.ws.server.endpoint.adapter.GenericMarshallingMethodEndpointAdapter">
	    <property name="marshaller" ref="marshaller" />
	    <property name="unmarshaller" ref="marshaller" />
	</bean>
</beans>

```

And finally implement your service endpoint class like this:

```
package com.acme.coolservice.pox;

import org.springframework.ws.server.endpoint.annotation.Endpoint;
import org.springframework.ws.server.endpoint.annotation.PayloadRoot;

import com.acme.coolservice.jaxb.*;

@Endpoint
public class CoolServiceEndpoint {

    @PayloadRoot(localPart="foo")
    public FooResponse foo(FooRequest request) {
        return new FooResponse();
    }

    @PayloadRoot(localPart="bar")
    public BarResponse bar(BarRequest request) {
        return new BarResponse();
    }

}

```

You can also make a client by adding this to your Spring context file:

```
<oxm:jaxb2-marshaller id="marshaller" contextPath="com.acme.coolservice.jaxb" />
    <bean id="messageFactory" class="org.springframework.ws.pox.dom.DomPoxMessageFactory" />
    <bean id="webServiceTemplate" class="org.springframework.ws.client.core.WebServiceTemplate">
        <property name="defaultUri" value="server-URI"/>
        <property name="marshaller" ref="marshaller"/>
        <property name="unmarshaller" ref="marshaller"/>
        <property name="messageFactory" ref="messageFactory"/>        
    </bean>    

```

And access it like this:

```
package com.acme.coolservice.client;

import com.acme.coolservice.jaxb.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ws.client.core.WebServiceTemplate;

public class CoolServiceClient {

    @Autowired
    private WebServiceTemplate webService;

    public void foo() {
        FooRequest request = new FooRequest();
        FooResponse response = (FooResponse)webService.marshalSendAndReceive(request);
    }

    public void bar() {
        BarRequest request = new BarRequest();
        BarResponse response = (BarResponse)webService.marshalSendAndReceive(request);
    }

}

```

The client uses the same JAXB classes as the server.

When running Java 6, or Java 5 inside a JavaEE 5 compliant application server, you already have the JAXB 2.x runtime available. If you run Java 5 without such application server, you have to include JAXB 2.x runtime libraries in your project.

You need these dependencies:

```
<dependency>
            <groupId>org.springframework.ws</groupId>
            <artifactId>spring-ws-core</artifactId>
            <version>1.5.9</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.ws</groupId>
            <artifactId>spring-ws-core-tiger</artifactId>
            <version>1.5.9</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.ws</groupId>
            <artifactId>spring-oxm-tiger</artifactId>
            <version>1.5.9</version>
        </dependency>

```

You may have to make this exclusion from `spring-ws-core` when running in some application servers such as WebLogic:

```
<exclusions>
    <exclusion>
        <groupId>wsdl4j</groupId>
        <artifactId>wsdl4j</artifactId>
    </exclusion>
</exclusions>
```

**Update:**  
Include this in `WEB-INF/web.xml`:

```
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>/WEB-INF/spring-ws-servlet.xml</param-value>
</context-param>
  
<servlet>
    <servlet-name>context</servlet-name>
    <servlet-class>org.springframework.web.context.ContextLoaderServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet>
    <servlet-name>spring-ws</servlet-name>
    <servlet-class>org.springframework.ws.transport.http.MessageDispatcherServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>spring-ws</servlet-name>
    <url-pattern>/*</url-pattern>
</servlet-mapping>

```

 [1]: http://static.springsource.org/spring-ws/sites/1.5/
 [2]: http://java.sun.com/javase/6/docs/technotes/guides/xml/jaxb/index.html
 [3]: http://en.wikipedia.org/wiki/SOAP
 [4]: http://en.wikipedia.org/wiki/XML-RPC
 [5]: https://jaxb.dev.java.net/nonav/2.0.2/docs/xjc.html