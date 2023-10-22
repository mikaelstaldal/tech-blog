---
year: 2015
month: 2015/07
day: 2015/07/21
title: 'Leafpad > gedit'
author: Mikael Ståldal
type: post
date: 2015-07-21T10:22:35+00:00
slug: leafpad-gedit
category:
  - Linux
  - Ubuntu

---
I want a simple, fast and lightweight text editor for my Linux desktop. I don&#8217;t want to learn a lot of new arcane key bindings, so not Vim or Emacs. I want a real GUI desktop application, not a console based one, so not [nano][1] (even though nano is nice when you only have a text console available). I don&#8217;t want a full-blown IDE for programming (I already have that) so I don&#8217;t need syntax highlighting and similar features.

So far I have been using [gedit][2] which is bundled as default text editor with Ubuntu. But it is not lightweight and sometimes really slow. It is particularly bad at handling large files and slow at searching, searching for a word in a 5 MB text file was painfully slow on my quite fast computer.

I got fed up with gedit and went out to look for alternatives. I found [Leafpad][3] and really like it. It is available in the standard Ubuntu APT repository, so it is trivial to install. It is GTK+ based (just like gedit), so it integrates nicely with the Unity desktop, it even supports the Unity global menu bar.

Leafpad is really lightweight and much faster than gedit. Searching through a 5 MB text file is not a problem at all.

Leafpad lacks some of the features that gedit have. It doesn&#8217;t support multiple files in tabs, but since it&#8217;s lightweight you can start multiple instances of it in separate windows, and the [tab support in gedit is not very good anyway][4]. It does not support syntax highlighting, but for me gedit is not good enough for serious programming anyway, I want a real IDE with more than just syntax highlighting for that.

Now gedit is uninstalled from my machine and I don&#8217;t miss it.

 [1]: http://www.nano-editor.org/
 [2]: https://wiki.gnome.org/Apps/Gedit
 [3]: http://tarot.freeshell.org/leafpad/
 [4]: https://bugzilla.gnome.org/show_bug.cgi?id=314646