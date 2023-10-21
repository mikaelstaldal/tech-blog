---
title: Running Adobe Lightroom 4.4 in Ubuntu 14.04
author: Mikael Ståldal
type: post
date: 2014-12-26T11:46:47+00:00
url: /2014/12/26/running-adobe-lightroom-4-4-in-ubuntu-14-04/
category:
  - Linux
  - Ubuntu
  - wine

---
I use Adobe Lightroom 4.4 for photo editing. There is one very annoying aspect of this program, it is not available for Linux (only for Windows and Max OS X).

In order to run Lightroom on my computer, I had to use VirtualBox and install Windows 7 in it. This works, but is quite clumsy and annoying. And since Lightroom is the only reason for me to run Windows, I would like to get rid of it.

So I decided to try out [Wine][1]. The current version of Wine does not support Lightroom out of the box, but I found some patches and tricks which makes it work. This is how I did it, for Ubuntu 14.04 32-bit (might work in older versions as well).

  1. Uninstall any Wine installation you might already have
  2. Install stuff necessary to build Wine:  
    `sudo apt-get build-dep wine1.6`
  3. Download and unpack [Wine 1.7.33 sources][2]:  
    `tar -xjf ~/Downloads/wine-1.7.33.tar.bz2`
  4. Apply [this patch][3]:  
    `patch -p0 <Menu-wine-1.7.33.patch`
  5. Build and install the patched Wine 1.7.33:  
    `cd wine-1.7.33`  
    `./configure`  
    `make`  
    `sudo make install`
  6. Install winetricks:  
    `sudo apt-get install cabextract`  
    `cd /usr/local/bin`  
    `sudo wget http://winetricks.org/winetricks`  
    `sudo chmod +x winetricks`
  7. Prepare and install Lightroom 4.4.1 32-bit:  
    `winetricks win7`  
    `wine ~/Downloads/Lightroom_4_LS11_win_4_4_1.exe`  
    `winetricks winxp`  
    `winetricks gdiplus corefonts ie7`
  8. Download unpack and install [sRGB color profile][4]:  
    `tar -xzf ~/Downloads/lr-wine-1.5.17.tar.gz`  
    `cp "sRGB Color Space Profile.icm" ~/.wine/drive_c/windows/system32/spool/drivers/color`

Now you can start Lightroom with this command:  
`wine "C:\\Program Files\\Adobe\\Adobe Photoshop Lightroom 4.4.1\\lightroom.exe"`

I found most of the information [here][5], thanks to Roland Baudin who did most of the job.

 [1]: http://www.winehq.org/
 [2]: http://sourceforge.net/projects/wine/files/Source/wine-1.7.33.tar.bz2/download
 [3]: /tech/Menu-wine-1.7.33.patch
 [4]: http://roland65.free.fr/lr-wine-1.5.17.tar.gz
 [5]: http://bugs.winehq.org/show_bug.cgi?id=30164#c37