---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
author: 'Mikael Ståldal'
type: post
date: {{ .Date }}
url: /{{ dateFormat "2006/01/02" .Date }}/{{.File.ContentBaseName}}/
draft: true
categories:
  - Uncategorized

---
