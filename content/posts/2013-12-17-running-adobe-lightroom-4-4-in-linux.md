---
title: Running Adobe Lightroom 4.4 in Linux
author: Mikael Ståldal
type: post
date: 2013-12-17T18:27:50+00:00
slug: running-adobe-lightroom-4-4-in-linux
category:
  - Linux
  - Ubuntu

---
I use Adobe Lightroom 4.4 for photo editing. There is one very annoying aspect of this program, it is not available for Linux (only for Windows and Max OS X).

In order to run Lightroom on my computer, I had to use VirtualBox and install Windows 7 in it. This works, but is quite clumsy and annoying. And since Lightroom is the only reason for me to run Windows, I would like to get rid of it.

So I decided to try out [Wine][1]. The current version of Wine does not support Lightroom out of the box, but I found some patches which seems make it work. This is how I did it, for Ubuntu 12.04 32-bit.

  1. Uninstall any Wine installation you might already have
  2. Prepare to build Wine from source (for some odd reason, it should be `wine1.4` and not `wine1.6`): 
```
sudo apt-get build-dep wine1.4
```

  3. Download [Wine 1.6 sources][2]
  4. Unpack Wine 1.6 sources: 
```
tar -xjf ~/Downloads/wine-1.6.tar.bz2
```

  5. Download the [necessary patches][3]
  6. Unpack and apply the paches: 
```
tar -xzf ~/Downloads/wine-1.6-lr5-patches.tar.gz
patch -p0 <0-Menu-wine-1.6.patch
patch -p0 <1-ConditionVariables-wine-1.6.patch
patch -p0 <2-InitOnceExecuteOnce-wine-1.6.patch
```

  7. Build and install the patched Wine 1.6: 
```
cd wine-1.6
./configure
make
sudo make install

```

  8. Install [winetricks][4]: 
```
cd /usr/local/bin
sudo wget http://winetricks.org/winetricks
sudo chmod +x winetricks

```

  9. Install cabextract: 
```
sudo apt-get install cabextract

```

 10. Prepare and install Lightroom 4.4.1 32-bit: 
```
winetricks win7
wine ~/Downloads/Lightroom_4_LS11_win_4_4_1.exe
winetricks winxp
winetricks corefonts gdiplus ie7

```

 11. Download [sRGB color profile][5]
 12. Unpack and install sRGB color profile: 
```
tar -xzf ~/Downloads/lr-wine-1.5.17.tar.gz
cp "sRGB Color Space Profile.icm" ~/.wine/drive_c/windows/system32/spool/drivers/color

```

Now you can start Lightroom with this command: 

```
wine "C:\\Program Files\\Adobe\\Adobe Photoshop Lightroom 4.4.1\\lightroom.exe"

```

I found most of the information [here][6].

 [1]: http://www.winehq.org/
 [2]: http://sourceforge.net/projects/wine/files/Source/wine-1.6.tar.bz2/download
 [3]: http://bugs.winehq.org/attachment.cgi?id=46346
 [4]: http://wiki.winehq.org/winetricks
 [5]: http://roland65.free.fr/lr-wine-1.5.17.tar.gz
 [6]: http://bugs.winehq.org/show_bug.cgi?id=30164#c37