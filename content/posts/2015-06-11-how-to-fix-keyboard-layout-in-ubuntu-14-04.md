---
title: How to fix keyboard layout in Ubuntu 14.04
author: Mikael Ståldal
type: post
date: 2015-06-11T19:25:55+00:00
slug: how-to-fix-keyboard-layout-in-ubuntu-14-04
category:
  - Linux
  - Ubuntu

---
I regularly use Swedish keyboard layout, but I keep the English layout around in case I would like to temporary switch to it.

Ubuntu 14.04 sometimes mess this up and I suddenly get English layout when I log in. I fix this by installing `dconf-editor`, go to `desktop/ibus/general`, and make sure that the values `engines-order` and `preload-engines` are the same and in the desired order with the default layout first.