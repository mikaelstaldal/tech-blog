---
title: '{{ replace (slicestr .File.ContentBaseName 11) "-" " " | title }}'
slug: {{ slicestr .File.ContentBaseName 11 }}
author: 'Mikael Ståldal'
type: post
date: {{ .Date }}
year: {{ dateFormat "2006" .Date }}
month: {{ dateFormat "2006/01" .Date }}
day: {{ dateFormat "2006/01/02" .Date }}
draft: true
category:
  - Uncategorized

---
