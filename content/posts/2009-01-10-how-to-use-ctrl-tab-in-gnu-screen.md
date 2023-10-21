---
title: How to use Ctrl-Tab in GNU Screen
author: Mikael Ståldal
type: post
date: 2009-01-10T18:37:12+00:00
url: /2009/01/10/how-to-use-ctrl-tab-in-gnu-screen/
category:
  - Linux

---
[GNU Screen][1] allows you to open several sub-windows within one terminal window. By default, you switch between them using `Ctrl-A` followed by `n` or `p`. I think this is a bit clumsy, I would like to switch with `Ctrl-Tab` and `Ctrl-Shift-Tab` just like you switch tabs in [Firefox][2] and many other applications. The sub-windows in Screen is conceptually just like tabs in Firefox, so it&#8217;s logical to use the same keys to switch between them.

Screen can be configured to use any key combination for switching sub-window by using the `bindkey` command. However, Screen can only recognize the key combinations that your terminal emulator actually intercept and send a unique code for. By default, most terminal emulators do not intercept `Ctrl-Tab`, they just send the same code as for `Tab`. And you certainly not want to use that since `Tab` is used for [tab completion][3] in the shell.

So you need to configure your terminal emulator to intercept and send a unique code for `Ctrl-Tab`. In [xterm][4], you can do that by setting the [X resource][5] `XTerm.vt100.modifyOtherKeys: 2`. Now xterm sends `^[[27;5;9~` for `Ctrl-Tab` and `^[[27;6;9~` for `Ctrl-Shift-Tab` (`^[` is ESC). However, you don&#8217;t want to use this since it mess up other things. You need to configure just `Ctrl-Tab` and `Ctrl-Shift-Tab` without altering any other keys. This can be done using the translation feature. Add this to your `~/.Xresources` file (you need to log out for this to take effect):

```
*vt100.translations: #override \n\
        Ctrl ~Shift <Key>Tab: string(0x1b) string("[27;5;9~") \n \
        Ctrl Shift <Key>Tab: string(0x1b) string("[27;6;9~") \n

```

Then add this to your `~/.screenrc` file:

```
# Ctrl-Tab
bindkey "^[[27;5;9~" next

# Ctrl-Shift-Tab
bindkey "^[[27;6;9~" prev

```

This works in xterm. I&#8217;m not sure if it works in other terminal emulators.

 [1]: http://en.wikipedia.org/wiki/GNU_Screen
 [2]: http://www.mozilla.com/firefox/
 [3]: http://en.wikipedia.org/wiki/Tab_completion
 [4]: http://en.wikipedia.org/wiki/Xterm
 [5]: http://en.wikipedia.org/wiki/X_resources