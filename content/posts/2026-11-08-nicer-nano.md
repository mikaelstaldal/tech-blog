---
title: 'Nicer nano'
slug: nicer-nano
author: 'Mikael Ståldal'
type: post
date: 2026-11-08T11:00:00+01:00
year: 2026
month: 2026/11
day: 2026/11/08
category:
  - Linux
---

I don't use [nano](https://www.nano-editor.org) as my primary text editor, I prefer to use a desktop GUI text editor
whenever possible. But it is good to also have a terminal based editor available since you can use it when you log in to
a remote machine over SSH, and easily editing root owned files locally (that can be tricky with a desktop GUI text
editor).

My choice is [nano](https://www.nano-editor.org) since it is almost universally available, preinstalled on most Linux
machines and also available on MacOS. And compared to the other universally available text editor, vim, it is actually
usable!

For some reason, vim is usually set to the default terminal text editor on Linux, but you can override that by setting
the environment variable `EDITOR=nano`, e.g. by including `export EDITOR=nano` in `~/.profile`. Then nano will be used
by tools like `sudoedit` and `git commit`.

The default configuration of nano is usable, but a bit weird. But you can tweak the config to make it behave a bit more
like a modern GUI text editor. Put this in `~/.nanorc` and in `/root/.nanorc` on your machine, and on any remote machine
you have a user account on:

```
unset backup
unset historylog
set constantshow
set indicator
set minibar
set mouse
set nohelp
set tabsize 4

bind ^X cut main
bind ^C copy main
bind ^V paste all
bind ^Q exit all
bind ^S savefile main
bind ^W writeout main
bind ^O insert main
bind F1 help all
bind F1 exit help
bind ^F whereis all
bind F3 findnext all
bind F15 findprevious all # Shift-F3
bind ^R replace main
bind ^Z undo main
bind ^Y redo main
bind ^G gotoline main
bind ^G gotodir browser
bind ^E execute main

unbind Ins main

unbind F2 main
unbind F4 main
unbind F5 main
unbind F6 main
unbind F7 main
unbind F8 main
unbind F9 main
unbind F10 main
unbind F11 main
unbind F12 main

unbind ^/ main
unbind ^\ main
unbind ^] main
unbind ^Space main
unbind ^A main
unbind ^K main
unbind ^L main
unbind ^N main
unbind ^P main
unbind ^T main
unbind ^U all

unbind M-Space main
unbind M-/ main
unbind M-\ main
unbind M-( main
unbind M-) main
unbind M-. main
unbind M-, main
unbind M-" main
unbind M-' main
unbind M-^ main
unbind M-+ main
unbind M-- main
unbind M-_ main
unbind M-= main
unbind M-< main
unbind M-> main
unbind M-3 main
unbind M-6 main
unbind M-7 main
unbind M-8 main
unbind M-B main
unbind M-E main
unbind M-F main
unbind M-G main
unbind M-J main
unbind M-Q main
unbind M-R main
unbind M-T main
unbind M-U main
unbind M-W main
```
