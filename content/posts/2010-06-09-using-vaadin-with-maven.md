---
year: 2010
month: 2010/06
day: 2010/06/09
title: Using Vaadin with Maven
author: Mikael Ståldal
type: post
date: 2010-06-09T11:44:39+00:00
slug: using-vaadin-with-maven
category:
  - Java
  - web

---
[Vaadin][1] is a comprehensive framework for developing web applications in Java. The Vaadin web site presents a number of ways to use Vaadin with [Maven][2], but I am not completely satisfied with any of those. Here is how I do it.

Use a `pom.xml` like this:

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<groupId>com.thecompany</groupId>
	<artifactId>theapp</artifactId>
	<version>1.0</version>
	<packaging>war</packaging>
	<name>The App</name>
    
	<dependencies>
        <dependency>
            <groupId>com.vaadin</groupId>
            <artifactId>vaadin</artifactId>
            <version>6.3.3</version>
        </dependency>
	</dependencies>

	<build>
		<plugins>
	        <plugin>
	            <groupId>org.apache.maven.plugins</groupId>
	            <artifactId>maven-war-plugin</artifactId>
	            <configuration>
	              <overlays>
	                <overlay>
		              <groupId>com.vaadin</groupId>
		              <artifactId>vaadin</artifactId>
		              <type>jar</type>
		              <includes>
		                <include>VAADIN/**</include>
		              </includes>
	                </overlay>
	              </overlays>
	            </configuration>
	         </plugin>

		<plugin>
			<groupId>org.mortbay.jetty</groupId>
			<artifactId>maven-jetty-plugin</artifactId>
			<version>6.1.17</version>
		</plugin>
        </plugins>		
	</build>
</project>

```

And a `src/main/webapp/WEB-INF/web.xml` like this:

```
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
	http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">

	<context-param>
	    <param-name>productionMode</param-name> <!-- Vaadin parameter -->
	    <param-value>true</param-value>
	</context-param>

	<servlet>
		<servlet-name>TheApp</servlet-name>
		<servlet-class>com.vaadin.terminal.gwt.server.ApplicationServlet</servlet-class>
		<init-param>
			<param-name>application</param-name>
			<param-value>com.thecompany.theapp.TheApp</param-value>
		</init-param>
		<load-on-startup>1</load-on-startup>
	</servlet>
	<servlet-mapping>
		<servlet-name>TheApp</servlet-name>
		<url-pattern>/theapp/*</url-pattern>
	</servlet-mapping>
</web-app>

```

In this way, the `VAADIN` directory with themes and widgetsets from `vaadin.jar` will be automatically copied to the produced web-app where it can be served as static content for optimal performance. You can also put your own themes under `src/main/webapp/VAADIN/themes` and they will be merged with the default themes.

Build a `.war` file for your application using `mvn package`. You can also quickly test it using Jetty by running `mvn jetty:run-exploded` (`jetty:run` won&#8217;t work properly).

 [1]: http://vaadin.com/
 [2]: http://maven.apache.org/