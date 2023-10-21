---
title: Support fake Android TV devices
author: Mikael Ståldal
type: post
date: 2016-06-14T14:58:33+00:00
slug: support-fake-android-tv-devices
category:
  - Android

---
[Android TV][1] is included in some modern Smart TVs, and there are also external set-top-boxes to get Android TV for any TV with HDMI input.

However, there are also some set-top-boxes which almost, but not quite, support Android TV.

With not so much extra effort, it is possible to make an Android app supporting those fake Android TV devices as well as the real ones.

In addition to the [guidelines from Google][2] for building Android TV apps, do this to support the fake TV Android TV devices as well:

  1. If you build an app for both Android TV and mobile (smartphone/tablet), make sure to build a separate `.apk` for Android TV, using [Gradle flavors][3]. (This is a good idea anyway since it will keep down the `.apk` size.)
  2. Do not use the `television` [resource qualifier][4], put TV resources in unqualified resource directories instead. (When building a separate `.apk` for TV only, this resource qualifier is not necessary.)
  3. Specify both `android.intent.category.LAUNCHER` and `android.intent.category.LEANBACK_LAUNCHER` in the [intent-filter for the launcher activity][5] in the app manifest.: 
```
<intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LEANBACK_LAUNCHER" />
    <category android:name="android.intent.category.LAUNCHER" />
</intent-filter>

```

  4. Specify Leanback support with required=false in the app manifest: 
```
<uses-feature
    android:name="android.software.leanback"
    android:required="false" />

```

  5. Specify both `android:icon` and `android:banner` in the app manifest: 
```
<application
    android:banner="@drawable/my_banner"
    android:icon="@drawable/my_icon">

```

  6. If you use the [Leanback SearchFragment][6], you need to disable voice search on the fake devices, since they usually does not support speech recognition: 
```
static boolean isRealAndroidTvDevice(Context context) {
        UiModeManager uiModeManager = (UiModeManager) context.getSystemService(UI_MODE_SERVICE);
        return (uiModeManager.getCurrentModeType() == Configuration.UI_MODE_TYPE_TELEVISION);
    }        

    if (!isRealAndroidTvDevice(context)) {
        setSpeechRecognitionCallback(new SpeechRecognitionCallback() {
            @Override
            public void recognizeSpeech() {
                // do nothing
            }
        });
    }

```

  7. The fake Android TV devices usually get the display pixel density wrong. You can programatically fix this in `onCreate` on the launcher activity: 
```
if (!isRealAndroidTvDevice(context)) {
        DisplayMetrics metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
        metrics.density = 2.0f;
        metrics.densityDpi = 320;
        metrics.scaledDensity = 2.0f;
        getResources().getDisplayMetrics().setTo(metrics);
    }

```

 [1]: https://www.android.com/intl/sv_se/tv/
 [2]: https://developer.android.com/training/tv/start/start.html
 [3]: http://tools.android.com/tech-docs/new-build-system/user-guide#TOC-Product-flavors
 [4]: https://developer.android.com/guide/topics/resources/providing-resources.html#AlternativeResources
 [5]: https://developer.android.com/training/tv/start/start.html#dev-project
 [6]: https://developer.android.com/reference/android/support/v17/leanback/app/SearchFragment.html