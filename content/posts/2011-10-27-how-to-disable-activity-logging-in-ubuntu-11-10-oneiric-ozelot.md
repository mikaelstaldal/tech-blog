---
title: How to disable activity logging in Ubuntu 11.10 Oneiric Ozelot
author: Mikael Ståldal
type: post
date: 2011-10-27T17:09:56+00:00
slug: how-to-disable-activity-logging-in-ubuntu-11-10-oneiric-ozelot
category:
  - Linux
  - Ubuntu

---
Ubuntu has mechanism to log user activity such as used documents. This is used to facilitate searching, but can also be intrusive to your privacy.

Here is a way to disable this logging without breaking Unity or any other part of the system, execute these commands in a terminal:

  1. `sudo mv /etc/xdg/autostart/zeitgeist-datahub.desktop /etc/xdg/autostart/zeitgeist-datahub.desktop-inactive`
  2. `rm ~/.local/share/recently-used.xbel`
  3. `mkdir ~/.local/share/recently-used.xbel`
  4. `rm -rf ~/.local/share/zeitgeist`

then log out and log in again.