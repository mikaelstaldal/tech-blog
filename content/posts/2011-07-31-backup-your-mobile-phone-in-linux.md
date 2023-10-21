---
title: Backup your mobile phone in Linux
author: Mikael Ståldal
type: post
date: 2011-07-31T08:55:16+00:00
slug: backup-your-mobile-phone-in-linux
category:
  - Linux

---
To backup data from a non-smart SonyEricsson mobile phone (such as W890i) in Linux, use the [gammu][1] utility.

  1. Install [gammu][1], it is available as a package in the standard repositories for Debian and Ubuntu, just install the `gammu` package.
  2. Create a `~/.gammurc` file with the following content:> 
    > [gammu]  
    > port = /dev/ttyACM0  
    > connection = at 

  3. Connect your mobile phone to the computer with the USB cable and select `Phone mode`
  4. Use  
    > gammu backup *filename*.vcf -yes 
    
    to backup your phone book to a vCard file 
    
      * Use  
        > gammu geteachsms 
        
        to get all SMS stored in the phone (both sent and received), they will be written to STDOUT 
        
      * There is also a lot more you can do with [gammu][1]

 [1]: http://wammu.eu/