---
title: 'How to Publish a Gradle Project on Maven Central'
slug: how-to-publish-a-gradle-project-on-maven-central
author: 'Mikael Ståldal'
type: post
date: 2026-01-02T15:00:00+01:00
year: 2026
month: 2026/01
day: 2026/01/02
category:
  - Java
  - Kotlin
  - gradle
  - kotlin
---

You can publish a Java or [Kotlin](https://kotlinlang.org/) library built with [Gradle](https://gradle.org/) on [Maven Central](https://central.sonatype.org/register/central-portal/) like this.

First setup your Gradle build to produce a [valid bundle](https://central.sonatype.org/publish/publish-portal-upload/) for Maven Central.

1. Include the [Maven Publish Plugin](https://docs.gradle.org/8.5/userguide/publishing_maven.html) in your build.

2. Setup building of [Javadoc and Source archives](https://central.sonatype.org/publish/requirements/#supply-javadoc-and-sources) using [Dokka](https://kotlinlang.org/docs/dokka-gradle.html).

3. Set the [required POM metadata](https://central.sonatype.org/publish/requirements/#required-pom-metadata) in Gradle [like this](https://docs.gradle.org/8.5/userguide/publishing_maven.html#sec:modifying_the_generated_pom).

See [here](https://github.com/mikaelstaldal/kotlin-html-builder/blob/main/build.gradle.kts) for a complete working example.

Now you can run `gradle publish` to create the Maven bundle in the `mavenPublish` directory (which you probably want to include in `.gitignore`).

Maven Central also requires that you [sign the artifacts with OpenPGP](https://central.sonatype.org/publish/requirements/#sign-files-with-gpgpgp).
You can do that with [Gradle's signing plugin](https://docs.gradle.org/8.5/userguide/publishing_signing.html), but it's better to do signing and
the actual publishing outside of the build tool, to avoid the kind of [supply-chain attacks](https://www.trendmicro.com/en_us/research/25/i/npm-supply-chain-attack.html)
which currently plagues the NPM eco-system. If you run [Gradle in a sandbox](https://www.staldal.nu/tech/2025/09/14/gradle-apparmor/) and don't give it access to 
keys/credentials used for signing and publishing, then a compromized build will not be able to spread like a worm. You can sign the artifacts with this command:

```bash
find mavenPublish/ -type f \( -name '*.jar' -o -name '*.pom' -o -name '*.module' \) -execdir gpg --armor --detach-sign '{}' \;
```

Then create the bundle to be published:

```bash
(cd mavenPublish/ && zip -r ../central-bundle.zip .)
```

Finally, you can upload the bundle to Maven Central.
