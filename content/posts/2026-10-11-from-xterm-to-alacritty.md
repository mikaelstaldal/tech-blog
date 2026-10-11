---
title: 'From XTerm to Alacritty'
slug: from-xterm-to-alacritty
author: 'Mikael Ståldal'
type: post
date: 2026-10-11T12:00:00+02:00
year: 2026
month: 2026/10
day: 2026/10/11
category:
  - Linux
---

I have [written before](/tech/2023/10/14/from-screen-to-tmux/) how to support tabs and scrollback in XTerm with tmux.

Now it seems like [Wayland](https://en.wikipedia.org/wiki/Wayland_(protocol)) is replacing [X11](https://en.wikipedia.org/wiki/X_Window_System) 
as the default window system in Linux desktops. And XTerm, as the name implies, only supports X11. So I wanted to replace
XTerm with another terminal with native Wayland support.

After trying a few options, I decided to go with [Alacritty](https://alacritty.org/). As a bonus, you also get clickable hyperlinks (OSC 8).  

Here is how I configured it to work with tmux:

`~/.config/alacritty/alacritty.toml`:

```toml
[scrolling]
history = 0

[selection]
save_to_clipboard = true

[terminal]
osc52 = "Disabled"

[[keyboard.bindings]]
key = "Tab"
mods = "Control"
chars = "\u001b[27;5;9~"

[[keyboard.bindings]]
key = "Tab"
mods = "Control|Shift"
chars = "\u001b[27;6;9~"
```

`~/.tmux.conf`:

```
set -s extended-keys on
set -as terminal-features 'alacritty*:hyperlinks'

set -g status off
set -g set-titles on
set -g set-titles-string "#{W:#{window_index} #{window_name}  ,[#{window_index} #{window_name}]  }"
set -g mouse off

# Ctrl-Tab
# set -s user-keys[0] "\033[27;5;9~"
bind-key -T root C-Tab next-window

# Ctrl-Shift-Tab
# set -s user-keys[1] "\033[27;6;9~"
bind-key -T root C-BTab previous-window

# Shift-PageUp
set -s user-keys[2] "\033[5;2~"
bind-key -T root User2 copy-mode -eu
bind-key -T copy-mode User2 send-keys -X page-up

# Shift-PageDown
set -s user-keys[3] "\033[6;2~"
bind-key -T copy-mode User3 send-keys -X page-down
```

`~/.local/share/applications/alacritty-with-tmux.desktop`

```
[Desktop Entry]
Type=Application
Exec=alacritty -e tmux
X-GNOME-Autostart-enabled=true
Name=Alacritty with tmux
Icon=Alacritty
```
