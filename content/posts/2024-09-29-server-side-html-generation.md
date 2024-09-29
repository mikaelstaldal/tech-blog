---
title: 'Server-side HTML generation'
slug: server-side-html-generation
author: 'Mikael Ståldal'
type: post
date: 2024-09-29T16:17:00+02:00
year: 2024
month: 2024/09
day: 2024/09/29
category:
  - Java 
  - Kotlin
  - Web

---

I have been trying out [htmx](https://htmx.org/) with [Kotlin](https://kotlinlang.org/) and [http4k](https://www.http4k.org/).

To use htmx, you need some way of generating HTML on the server. In Kotlin, you have plenty of options, both Kotlin 
specific ones and everything from the broader Java/JVM ecosystem. There are two main categories here, 
[template languages](https://en.wikipedia.org/wiki/Web_template_system) and internal 
[DSLs](https://en.wikipedia.org/wiki/Domain-specific_language).

Given Kotlin's good support for internal DSLs, I decided to explore that route, and try
[kotlinx.html](https://github.com/Kotlin/kotlinx.html) and [HtmlFlow](https://htmlflow.org/). They both make great 
promises of encoding the entire HTML standard and enforce valid HTML at compile time. This sounds very nice in theory, 
but in practice they are quite a disappointment.

As you can see in [my sample project with kotlinx.html](https://github.com/mikaelstaldal/htmx-http4k-dsl),
integrating it with http4k is a slightly cumbersome for complete pages, and 
[really annoying for fragments](https://github.com/mikaelstaldal/htmx-http4k-dsl/blob/304a6a8e9b5ef480548d58d3135ff3f2d3eea0bc/src/main/kotlin/nu/staldal/htmxhttp4kdsl/HtmlHelper.kt) 
(possibility to generate HTML fragments is crucial for htmx). It also contributes significantly to compile time.

I also wanted to give HtmlFlow a try, but it was unreasonably difficult to get it to work in a convenient way when using
[data binding](https://htmlflow.org/features#data-binding), 
[layout and fragments](https://htmlflow.org/features#layout-and-partial-views-aka-fragments) at the same time, so I gave up.
Here is my [incomplete and unsuccessful attempt](https://github.com/mikaelstaldal/htmx-http4k-htmlflow).

My conclusion is that those advanced type-safe internal DSLs for HTML are just too heavy and complicated. They have some
advantages, but it's not worth the added [complexity](https://grugbrain.dev/#grug-on-complexity), 
[cognitive load](https://github.com/zakirullin/cognitive-load) and increased compile time. 

So I prefer using a template language instead. http4k have 
[built-in support for several template languages](https://www.http4k.org/guide/reference/templating/), and
I decided to try out [Thymeleaf](https://www.thymeleaf.org/), mostly since its 
[templates are well-formed HTML](https://www.thymeleaf.org/#natural-templates), 
and then you can use HTML tools and/or IDE support to ensure validity of the HTML (this works out-of-the-box in IntelliJ 
IDEA Ultimate). Seems to be the only one of the http4k supported templates with that property. Thymeleaf also has 
comprehensive [support for fragments and layouts](https://www.thymeleaf.org/doc/tutorials/3.1/usingthymeleaf.html#template-layout).
The result became quite nice, see [my sample project](https://github.com/mikaelstaldal/htmx-http4k-thymeleaf).
