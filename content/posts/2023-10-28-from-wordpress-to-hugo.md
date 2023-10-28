---
year: 2023
month: 2023/10
day: 2023/10/28
title: From WordPress to Hugo
author: Mikael Ståldal
type: post
date: 2023-10-28T12:00:00+02:00
slug: from-wordpress-to-hugo
category:
  - blog

---
I have used self-hosted [WordPress](https://wordpress.org/) for this blog since its start in 2006, but I finally got fed
up with having to frequently update WordPress itself and a bunch of plugins, or having to constantly worry about
security issues. Since I am the only one publishing on this blog, I decided to switch to a
[static site generator](https://en.wikipedia.org/wiki/Static_site_generator) instead, and I chose 
[Hugo](https://gohugo.io/), mainly because it is easy to install and does not require any heavy runtime (most of its 
competitors require Python, Ruby or Node.js).

I used [this tool](https://github.com/SchumacherFM/wordpress-to-hugo-exporter) to export the WordPress site to Hugo
format. I had to do some tweaks to get it to work properly:

* Convert HTML's `<pre>...</pre>` to Markdown's \`\`\` format (beware of line breaks after/before).
* Remove some HTML escaping such as `&lt;` and `&gt;`.
* Clean-up some `<p>`, `</p>` and `<br />` tags.
* Put any static content into `static` directory, and fix links to it.
* Move pages to `content`.
* Fix temporal archives with a script like this:
```bash
#/bin/bash

for file in `ls -1 |grep '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-'`; do
  year=`echo ${file} | sed 's|\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)-.*|\1|g'`
  month=`echo ${file} | sed 's|\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)-.*|\1/\2|g'`
  day=`echo ${file} | sed 's|\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)-.*|\1/\2/\3|g'`
  sed -i -e "1d" ${file}
  sed -i -e "1i day: ${day}" ${file}
  sed -i -e "1i month: ${month}" ${file}
  sed -i -e "1i year: ${year}" ${file}
  sed -i -e "1i ---" ${file}
done
```
* Add search with [Pagefind](https://pagefind.app/).
* And some more.

The source code for the blog is now on [GitHub](https://github.com/mikaelstaldal/tech-blog).

 