---
title: 'Simple HTML DSL for Kotlin'
slug: simple-kotlin-html-dsl
author: 'Mikael Ståldal'
type: post
date: 2025-01-02T17:00:00+02:00
year: 2025
month: 2025/01
day: 2025/01/02
category:
  - Java 
  - Kotlin
  - Web
---

As I [wrote a while ago](/tech/2024/09/29/server-side-html-generation/), I have been trying different approaches for server-side HTML generation in Kotlin, with focus on good support for generating partials without a single root element (which is important for [htmx](https://htmx.org/)).

Given Kotlin's good support for internal DSLs, I decided to explore that route, and try [kotlinx.html](https://github.com/Kotlin/kotlinx.html) and [HtmlFlow](https://htmlflow.org/). They both make great 
promises of encoding the entire HTML standard and enforce valid HTML at compile time. This sounds very nice in theory, but in practice they are quite a disappointment.

As you can see in [my sample project with kotlinx.html](https://github.com/mikaelstaldal/htmx-http4k-dsl),
integrating it with http4k is a slightly cumbersome for complete pages, and [really annoying for partials](https://github.com/mikaelstaldal/htmx-http4k-dsl/blob/304a6a8e9b5ef480548d58d3135ff3f2d3eea0bc/src/main/kotlin/nu/staldal/htmxhttp4kdsl/HtmlHelper.kt). It also contributes significantly to compile time, and is not particularly fast at runtime according to some benchmarks.

I also wanted to give HtmlFlow a try, but it was unreasonably difficult to get it to work in a convenient way when using [data binding](https://htmlflow.org/features#data-binding), [layout and fragments](https://htmlflow.org/features#layout-and-partial-views-aka-fragments) at the same time, so I gave up. Here is my [incomplete and unsuccessful attempt](https://github.com/mikaelstaldal/htmx-http4k-htmlflow).

My conclusion is that those two type-safe internal DSLs for HTML are just too heavy and complicated. They have some advantages, but it's not worth the added [complexity](https://grugbrain.dev/#grug-on-complexity), [cognitive load](https://github.com/zakirullin/cognitive-load) and increased compile time.

So I decided to try if I could make something simpler myself, inspired by [kotlinx.html](https://github.com/Kotlin/kotlinx.html) and [Kotlin XML builder](https://github.com/redundent/kotlin-xml-builder). However, both of those builds an internal tree representation before generating HTML, usually to just throw it away when after generating HTML once. I realized that was wasteful, so I decided to skip that and generate HTML directly, only create one object to keep some state during generation.

For me, it was easier to write my own library from scratch, than trying to figure out how to use kotlinx.html or HtmlFlow in a reasonable way.

The result: [Kotlin HTML builder](https://github.com/mikaelstaldal/kotlin-html-builder/). I also made a [simple example on how to use it](https://github.com/mikaelstaldal/htmx-http4k-html-builder/), and [a benchmark](https://github.com/mikaelstaldal/template-benchmark/) showing it is about twice as fast as kotlinx.html (though still slower than HtmlFlow).
