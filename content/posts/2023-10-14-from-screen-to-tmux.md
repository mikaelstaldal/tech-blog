---
title: From screen to tmux
author: Mikael Ståldal
type: post
date: 2023-10-14T18:40:21+00:00
slug: from-screen-to-tmux
category:
  - Linux

---
I have written about how to configure screen in XTerm to support [Ctrl-Tab][1] and [convenient scrolling back in history][2].

This has worked well for over a decade now, but it seems like screen is not developed very much any longer, and [tmux][3] has gained popularity as a more modern and actively developed alternative. So I decided to try it, and was able to replicate my setup with tmux instead of screen. The result was actually simpler, since tmux requires less modification of XTerm config.

Add this to your `~/.Xresources` file (you need to log out or run `xrdb <~/.Xresources` for this to take effect):

```
xterm-tmux*saveLines: 0
xterm-tmux*vt100.translations: #override \n\
                Shift <KeyPress> Prior: string(0x1b) string("[25S") \n\
                Shift <KeyPress> Next: string(0x1b) string("[25T") \n

```

Add this to your `~/.tmux.conf` file:

```
set -s extended-keys on
set -s copy-command 'xsel -i -p -b'

set -g status off
set -g set-titles on
set -g set-titles-string "#{W:#{window_index} #{window_name}  ,[#{window_index} #{window_name}]  }"
set -g mouse on

# Ctrl-Tab
bind-key -T root C-Tab next-window

# Ctrl-Shift-Tab
set -s user-keys[0] "\033[Z"
bind-key -T root User0 previous-window

# Shift-PageUp
set -s user-keys[1] "\033[25S"
bind-key -T root User1 copy-mode -eu
bind-key -T copy-mode User3 send-keys -X page-up

# Shift-PageDown
set -s user-keys[2] "\033[25T"
bind-key -T copy-mode User2 send-keys -X page-down

```

You need to have XTerm, tmux and xsel installed. Then start it with `xterm -name xterm-tmux -e tmux`

 [1]: https://www.staldal.nu/tech/2009/01/10/how-to-use-ctrl-tab-in-gnu-screen/
 [2]: https://www.staldal.nu/tech/2009/01/11/how-to-use-mousewheel-in-gnu-screen/
 [3]: https://github.com/tmux/tmux