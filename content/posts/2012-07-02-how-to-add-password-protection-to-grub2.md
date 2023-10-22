---
year: 2012
month: 2012/07
day: 2012/07/02
title: How to add password protection to GRUB2
author: Mikael Ståldal
type: post
date: 2012-07-02T21:40:53+00:00
slug: how-to-add-password-protection-to-grub2
category:
  - Linux
  - security
  - Ubuntu

---
These instructions are tested with Ubuntu desktop 12.04, but will probably be useful in other Linux distros with GRUB2 as well.

The goal is to block everything except booting the default system. In paricular, it should not be possible for anyone to boot into recovery mode, since that will bypass normal login and give root access directly.

1. Run `grub-mkpasswd-pbkdf2` from a terminal and enter the desired password, copy the output.
2. Edit `/etc/grub.d/40_custom` and add this to the end: 
```
set superusers="root"
password_pbkdf2 root output from grub-mkpasswd-pbkdf2 goes here
password bogus bogus
```

3. Make `/etc/grub.d/40_custom` non-readable for users:  
    `chmod o-r /etc/grub.d/40_custom`
4. Edit `/etc/grub.d/10_linux` according to this diff: 
```
90c90,94
<   printf "menuentry '${title}' ${CLASS} {\n" "${os}" "${version}"
---
>   if ${recovery} || ${in_submenu}; then
>     printf "menuentry '${title}' ${CLASS} --users '' {\n" "${os}" "${version}"
>   else
>     printf "menuentry '${title}' ${CLASS} {\n" "${os}" "${version}"
>   fi
258c262
<     echo "submenu \"Previous Linux versions\" {"
---
>     echo "submenu \"Previous Linux versions\" --users '' {"

```

5. Edit `/etc/grub.d/20_memtest86+` according to this diff: 
```
27c27
< menuentry "Memory test (memtest86+)" {
---
> menuentry "Memory test (memtest86+)" --users "" {
33c33
< menuentry "Memory test (memtest86+, serial console 115200)" {
---
> menuentry "Memory test (memtest86+, serial console 115200)" --users "" {
46c46
< #menuentry "Memory test (memtest86+, experimental multiboot)" {
---
> #menuentry "Memory test (memtest86+, experimental multiboot)" --users "" {
52c52
< #menuentry "Memory test (memtest86+, serial console 115200, experimental multiboot)" {
---
> #menuentry "Memory test (memtest86+, serial console 115200, experimental multiboot)" --users "" {

```

6. Run `update-grub`

(I am not sure if it is possible to abuse memtest86+, but better safe than sorry.)

See [this page][1] for more information.

Please note that this by itself does not give you a secure system. It should be combined password protection for BIOS setup and for booting from removable media (CD-ROM) and USB devices. And you should not allow login without password in the main Linux system.

None of these measures protect from serious tampering with the hardware, such as removing the internal HDD and connecting it as non-boot device to another computer.

 [1]: https://help.ubuntu.com/community/Grub2/Passwords