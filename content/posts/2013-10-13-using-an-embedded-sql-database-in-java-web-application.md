---
year: 2013
month: 2013/10
day: 2013/10/13
title: Using an embedded SQL database in Java web application
author: Mikael Ståldal
type: post
date: 2013-10-13T10:06:29+00:00
slug: using-an-embedded-sql-database-in-java-web-application
category:
  - Java
  - JavaEE
  - web

---
You have a Java web application needing a relational SQL database. According to JavaEE conventions, you declare the DataSource in `web.xml`:

```
<resource-ref>
    <res-ref-name>jdbc/DS</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
</resource-ref>

```

and then fetch it in code with `(DataSource)new InitialContext().lookup("java:comp/env/jdbc/DS")`.

Using Maven, Jetty and HSQLDB, you can very easily run the web application for local testing without having to setup neither a web container, nor a database. Add this to `pom.xml`:

```
<build>
    <plugins>
        <plugin>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-maven-plugin</artifactId>
            <version>9.0.5.v20130815</version>
            <configuration>
                <webApp>
                    <contextPath>/${project.name}</contextPath>
                    <jettyEnvXml>src/etc/jetty-ds.xml</jettyEnvXml>
                </webApp>
            </configuration>
            <dependencies>
                <dependency>
                    <groupId>org.hsqldb</groupId>
                    <artifactId>hsqldb</artifactId>
                    <version>2.3.1</version>
                 </dependency>
            </dependencies>
        </plugin>
    </plugins>
</build>

```

And add a file `src/etc/jetty-ds.xml` to your project:

```
<!DOCTYPE Configure PUBLIC "-//Mort Bay Consulting//DTD Configure//EN" "http://www.eclipse.org/jetty/configure_9_0.dtd">
<Configure id="wac" class="org.eclipse.jetty.webapp.WebAppContext">
  <New id="DS" class="org.eclipse.jetty.plus.jndi.Resource">
    <Arg><Ref refid="wac"/></Arg>
    <Arg>jdbc/DS</Arg>
    <Arg>
      <New class="org.hsqldb.jdbc.JDBCDataSource">
        <Set name="DatabaseName">mem:db</Set>
        <Set name="User">SA</Set>
        <Set name="Password">""</Set>
      </New>
    </Arg>
  </New>
</Configure>

```

Then run it locally with `mvn jetty:run`. The database will be in-memory and does not presist between runs. It is also possible to configure HSQLDB to persist data on disk, see [documentation][1].

If you want to have access to in-memory database in your tests, add this dependency to `pom.xml`:

```
<dependencies>
    <dependency>
        <groupId>org.hsqldb</groupId>
        <artifactId>hsqldb</artifactId>
        <version>2.3.1</version>
        <scope>test</scope>
    </dependency>
</dependencies>

```

And create the DataSource in your test code like this:

```
import org.hsqldb.jdbc.JDBCDataSource;

        JDBCDataSource hsqldbDs = new JDBCDataSource();
        hsqldbDs.setDatabaseName("mem:.");
        hsqldbDs.setUser("SA");
        hsqldbDs.setPassword("");

```

_Note:_ This will not add the DataSource to JNDI.

 [1]: http://hsqldb.org/doc/2.0/guide/index.html