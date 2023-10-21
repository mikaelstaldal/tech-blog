---
title: Custom Preference for Android
author: Mikael Ståldal
type: post
date: 2015-05-16T10:34:02+00:00
url: /2015/05/16/custom-preference-for-android/
categories:
  - Android

---
I need a setting with a numeric value in my Android app. There is no obvious fit among the standard Preferences in Android, so I decided to implement my own [Preference][1] subclass.

This was a bit more involved than what I hoped for. I ended up with this. An improvement would be to be able to configure min and max values through XML attributes.

```
public class NumericPreference extends DialogPreference {
    private static final int DEFAULT_VALUE = 0;

    private NumberPicker mWidget;

    private int value = DEFAULT_VALUE;

    public NumericPreference(Context context, AttributeSet attrs) {
        super(context, attrs);

        setDialogLayoutResource(R.layout.numeric_dialog);
    }

    @Override
    protected void onBindDialogView(View view) {
        mWidget = (NumberPicker)view.findViewById(R.id.picker);
        mWidget.setMinValue(0);
        mWidget.setMaxValue(10);
        mWidget.setValue(value);
        super.onBindDialogView(view);
    }

    @Override
    protected Object onGetDefaultValue(TypedArray a, int index) {
        return a.getInteger(index, DEFAULT_VALUE);
    }

    @Override
    protected void onSetInitialValue(boolean restorePersistedValue, Object defaultValue) {
        if (restorePersistedValue) {
            value = getPersistedInt(DEFAULT_VALUE);
        } else {
            value = (Integer)defaultValue;
            persistInt(value);
        }
    }

    @Override
    protected void onDialogClosed(boolean positiveResult) {
        if (positiveResult) {
            value = mWidget.getValue();
            persistInt(value);
        }
    }
}

```

```
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:layout_width="match_parent"
              android:layout_height="match_parent"
              android:orientation="vertical"
              android:gravity="center_horizontal">

    <NumberPicker
            android:id="@+id/picker"
            android:layout_width="match_parent"
            android:layout_height="wrap_content" />

</LinearLayout>

```

The code is covered by [Apache License 2.0][2].

 [1]: http://developer.android.com/reference/android/preference/Preference.html
 [2]: http://www.apache.org/licenses/LICENSE-2.0