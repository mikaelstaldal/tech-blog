---
title: How to run exec-maven-plugin only if a file is not up-to-date
author: Mikael Ståldal
type: post
date: 2019-07-30T15:17:55+00:00
slug: how-to-run-exec-maven-plugin-only-if-a-file-is-not-up-to-date
category:
  - Java
  - maven
  - programming

---
In my Maven build, I use [exec-maven-plugin][1] to run an external tool for Java code generation. In this case the [flatbuffers][2] compiler (`flatc`).

By default, `flatc` always runs, so you always get a new `.java` file. This will always trigger Java compiler to run, which will in turn always trigger `jar` packaging to run, etc. I would like `flatc` to only run if it&#8217;s source file is updated, so I can get a properly incremental build and avoid needlessly recompiling.

`flatc` itself is not Java based, it does not support conditional execution, and there is no specific Maven plugin wrapping this tool. (There are specific Maven plugins for some other similar tools, like [`protoc`][3].)

I was able to do it by using [`build-helper-maven-plugin`][4], like this:

```
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>build-helper-maven-plugin</artifactId>
  <version>3.0.0</version>
  <executions>
    <execution>
      <id>fbs-register-sources</id>
      <phase>generate-sources</phase>
      <goals>
        <goal>add-source</goal>
      </goals>
      <configuration>
        <sources>
          <source>${project.build.directory}/generated-sources/flatc</source>
        </sources>
      </configuration>
    </execution>
    <execution>
      <id>check-fbs-compile</id>
      <phase>generate-sources</phase>
      <goals>
        <goal>uptodate-property</goal>
      </goals>
      <configuration>
        <name>flatc.notRequired</name>
        <fileSet>
          <directory>${project.basedir}/src/main/fbs</directory>
          <outputDirectory>${project.build.directory}/generated-sources/flatc</outputDirectory>
          <includes>
            <include>my.fbs</include>
          </includes>
          <mapper>
            <type>merge</type>
            <to>My.java</to>
          </mapper>
        </fileSet>
      </configuration>
    </execution>
  </executions>
</plugin>
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>exec-maven-plugin</artifactId>
  <executions>
    <execution>
      <id>fbs-compile</id>
      <phase>generate-sources</phase>
      <goals>
        <goal>exec</goal>
      </goals>
      <configuration>
        <skip>${flatc.notRequired}</skip>
        <!-- ... -->

```

 [1]: https://www.mojohaus.org/exec-maven-plugin/exec-mojo.html
 [2]: https://google.github.io/flatbuffers/
 [3]: https://www.xolstice.org/protobuf-maven-plugin/
 [4]: https://www.mojohaus.org/build-helper-maven-plugin/uptodate-property-mojo.html