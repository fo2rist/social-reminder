package com.weezlabs.socialreminder;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class ReminderDisplayActivity extends Activity {

    private TextView mTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_reminder_display);
        mTextView = (TextView) findViewById(R.id.text);
    }
}
