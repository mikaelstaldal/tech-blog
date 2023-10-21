---
title: Using AAC music files in Android
author: Mikael Ståldal
type: post
date: 2013-01-01T22:12:42+00:00
url: /2013/01/01/using-aac-music-files-in-android/
categories:
  - Android
  - Linux

---
If you have a file with `.aac` extension, it is [AAC][1] encoded audio in an [ADTS container][2]. If you want to play such file on an Android device, you have problems. Android 2.x does not support this file format at all, and not even the latest version of Android supports reading metadata tags from it.

The solution is to repackage the audio in an [MPEG-4 container][3] to a file with `.m4a` extension. Android can both play and read metadata tags from such files.

This can be done with the [MP4Box tool][4]. You can also add metadata tags while repackaging:  
```
MP4Box -itags "artist=${ARTIST}:name=${TITLE}:genre=${GENRE}" -add ${FILENAME}.aac#audio ${FILENAME}.m4a
``` 

If I understand it correctly, this will not recode the actual audio data, and thus not affect the quality in any way. The file size will also be almost the same.

 [1]: http://en.wikipedia.org/wiki/Advanced_Audio_Coding
 [2]: http://en.wikipedia.org/wiki/Advanced_Audio_Coding#Container_formats
 [3]: http://en.wikipedia.org/wiki/MPEG-4_Part_3#Audio_storage_and_transport
 [4]: http://gpac.wp.mines-telecom.fr/mp4box/