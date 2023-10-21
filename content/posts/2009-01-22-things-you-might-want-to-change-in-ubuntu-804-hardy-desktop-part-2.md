---
title: Things you might want to change in Ubuntu 8.04 (hardy) desktop, part 2
author: Mikael Ståldal
type: post
date: 2009-01-22T12:30:50+00:00
slug: things-you-might-want-to-change-in-ubuntu-804-hardy-desktop-part-2
category:
  - Linux

---
After installing Ubuntu 8.04 (hardy) desktop, there are some things you might want to change. This article focus on user configuration (mostly editing dot files in your home directory) and do not require superuser access. Some of this changes requires that you log out to take effect.

##### Customize the [bash][1] shell

By default, bash save all commands in a history file. This can be quite annoying when you run several instances of the shell in parallel, and may also be a security concern. Add this line at the beginning of `~/.bashrc` to only keep command in memory until you exit the shell:

```
unset HISTFILE

```

##### Customize the [nano][2] editor

Add this to `~/.nanorc``:
```

unset backup
unset historylog
set nowrap
set quickblank
set tabsize 4
set morespace

```
##### Customize [XTerm](http://en.wikipedia.org/wiki/Xterm)
I prefer to use xterm instead of the default GNOME terminal. xterm does not look so good by default, by using this you can get it to look almost like GNOME terminal, but faster and with smaller memory footprint. Add this to` `~/.Xresources`:

```
XTerm*faceName: monospace
XTerm*faceSize: 10
XTerm*vt100.Background: white
XTerm*vt100.Foreground: black
XTerm*vt100.metaSendsEscape: true

xterm*saveLines: 1000
xterm*vt100.translations: #override \n\
                 <BtnUp>: select-end(PRIMARY, CLIPBOARD, CUT_BUFFER0) \n

```

Then open &#8220;Preferred Applications&#8221; in &#8220;Preferences&#8221; in the System menu, open the &#8220;System&#8221; tab and select &#8220;Standard XTerminal&#8221;.

See also [part 1][3].

 [1]: http://en.wikipedia.org/wiki/Bash
 [2]: http://www.nano-editor.org/
 [3]: http://www.staldal.nu/tech/2009/01/16/things-you-might-want-to-change-in-ubuntu-804-hardy-desktop-part-1/