---
title: 'Simple web app with Go'
slug: simple-webapp-with-go
author: 'Mikael Ståldal'
type: post
date: 2025-07-12T19:00:00+02:00
year: 2025
month: 2025/07
day: 2025/07/12
category:
  - Go
  - Web
---

I have been learning the [Go programming language](https://go.dev/) lately, and it's remarkably easy to build simple 
web apps with it. In particular, with just a few simple tricks, you can make the deployment of such web apps super 
simple: just one single standalone statically linked binary which stores its data in one single file.

The Go standard library contains everything needed to build a basic web app:
* A [production-ready HTTP server](https://pkg.go.dev/net/http#Server)
* An [URL router](https://pkg.go.dev/net/http#ServeMux)
* Interface for [SQL databases](https://pkg.go.dev/database/sql)
* Parsing [command line options](https://pkg.go.dev/flag)
* [Simple logging](https://pkg.go.dev/log)
* [HTML templating](https://pkg.go.dev/html/template)
* [HTTP client](https://pkg.go.dev/net/http#Client)

If you use the [embed](https://pkg.go.dev/embed) feature, you can embed templates and static resources (CSS, JavaScript, 
images) and produce one single self-contained binary.

If you build with [go build -tags netgo](https://pkg.go.dev/net#hdr-Name_Resolution), and otherwise avoid 
[cgo](https://pkg.go.dev/cmd/cgo), you can build a statically linked binary on Linux. 

In Go, it's straightforward to use [SQLite](https://sqlite.org) as the relational database; you can store your data in 
one single file with a [well-defined format](https://sqlite.org/fileformat2.html) and [zero configuration](https://sqlite.org/zeroconf.html).
I recommend [this SQLite implementation for Go](https://pkg.go.dev/modernc.org/sqlite) which doesn't rely on cgo.
