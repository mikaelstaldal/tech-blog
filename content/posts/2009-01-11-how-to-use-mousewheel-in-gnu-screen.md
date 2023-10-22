---
year: 2009
month: 2009/01
day: 2009/01/11
title: How to use mousewheel in GNU Screen
author: Mikael Ståldal
type: post
date: 2009-01-11T21:02:41+00:00
slug: how-to-use-mousewheel-in-gnu-screen
category:
  - Linux

---
[GNU Screen][1] has support for scrollback, but by default you have to use awkward keys to use it. I would like to be able to use `Shift-PageUp`, `Shift-PageDown` and the mousewheel to scroll, just like you can do in [xterm][2].

It was not easy to configure Screen for this, and it involves cooperation with the terminal emulator. But I finally managed to achieve a solution which works pretty well. Add this to your `~/.Xresources` file (create it f you don’t have it already) (you need to log out for this to take effect):

```
XTerm*saveLines: 0
XTerm*vt100.translations: #override \n\
  Ctrl <Btn4Down>: string(0x1b) string("[25S") \n\
  Lock Ctrl <Btn4Down>: string(0x1b) string("[25S") \n\
  Lock @Num_Lock Ctrl <Btn4Down>: string(0x1b) string("[25S") \n\
  @Num_Lock Ctrl <Btn4Down>: string(0x1b) string("[25S") \n\
  <Btn4Down>: string(0x1b) string("[5S") \n\
  Ctrl <Btn5Down>: string(0x1b) string("[25T") \n\
  Lock Ctrl <Btn5Down>: string(0x1b) string("[25T") \n\
  Lock @Num_Lock Ctrl <Btn5Down>: string(0x1b) string("[25T") \n\
  @Num_Lock Ctrl <Btn5Down>: string(0x1b) string("[25T") \n\
  <Btn5Down>: string(0x1b) string("[5T") \n\
  Shift <KeyPress> Prior: string(0x1b) string("[25S") \n\
  Shift <KeyPress> Next: string(0x1b) string("[25T") \n

```

Then add this to your `~/.screenrc` file:

```
defscrollback 1000

# Scroll up
bindkey -d "^[[5S" eval copy "stuff 5\025"
bindkey -m "^[[5S" stuff 5\025

# Scroll down
bindkey -d "^[[5T" eval copy "stuff 5\004"
bindkey -m "^[[5T" stuff 5\004

# Scroll up more
bindkey -d "^[[25S" eval copy "stuff \025"
bindkey -m "^[[25S" stuff \025

# Scroll down more
bindkey -d "^[[25T" eval copy "stuff \004"
bindkey -m "^[[25T" stuff \004

```

This works in xterm. I’m not sure if it works in other terminal emulators.

Note that this disables the normal scrolling support in xterm, you will only be able to scroll when using Screen. You might want to start xterm like this to always use Screen:

```
xterm -e screen

```

_Edit:_ Create `~/.Xresources` if you don’t have it already.

 [1]: http://en.wikipedia.org/wiki/GNU_Screen
 [2]: http://en.wikipedia.org/wiki/Xterm