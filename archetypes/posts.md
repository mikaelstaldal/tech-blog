---
title: '{{ replace (slicestr .File.ContentBaseName 11) "-" " " | title }}'
author: 'Mikael Ståldal'
type: post
date: {{ .Date }}
slug: {{ slicestr .File.ContentBaseName 11 }}
draft: true
category:
  - Uncategorized

---
