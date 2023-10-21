---
title: Create a self-contained .jar file with Maven
author: Mikael Ståldal
type: post
date: 2014-10-26T16:12:54+00:00
url: /2014/10/26/create-a-self-contained-jar-file-with-maven/
categories:
  - Java

---
If you want to create a self-contained .jar file, with all library dependencies included, you can do it with Maven. Include this in your pom.xml:

```
<build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>2.4</version>
                <configuration>
                    <archive>
                        <manifest>
                            <mainClass>com.yourcompany.youapp.Main</mainClass>
                        </manifest>
                    </archive>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
                <executions>
                    <execution>
                        <id>make-jar-with-dependencies</id>
                        <phase>package</phase>
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
	</plugins>
    </build>

```

Then when you run `mvn package`, you will get a `target/*-jar-with-dependencies.jar` file which you can run with `java -jar`.