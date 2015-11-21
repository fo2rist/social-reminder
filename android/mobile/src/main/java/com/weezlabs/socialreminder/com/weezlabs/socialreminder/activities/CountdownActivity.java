package com.weezlabs.socialreminder.com.weezlabs.socialreminder.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;

import com.weezlabs.socialreminder.R;
import com.weezlabs.socialreminder.datalayer.CountdownsManager;
import com.weezlabs.socialreminder.models.Countdown;

import java.util.Calendar;

public class CountdownActivity extends AppCompatActivity {
    public enum Mode {
        Edit,
        View
    }

    private static final String MODE_KEY = "mode_key";
    private static final String ID_KEY = "id_key";

    private Mode mode_;
    private String id_;

    /**
     * Launch Condound View ACtivity
     * @param id countdown id, optional
     */
    public static void launchForEvent(Context context, Mode mode, String id) {
        Intent intent = new Intent(context, CountdownActivity.class);
        intent.putExtra(MODE_KEY, mode);
        intent.putExtra(ID_KEY, id);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_countdown);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //get parameters from bundle
        mode_ = (Mode) getIntent().getSerializableExtra(MODE_KEY);
        id_ = getIntent().getStringExtra(ID_KEY);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        switch (mode_) {
            case Edit:
                getMenuInflater().inflate(R.menu.countdown_edit, menu);
                break;
            case View:
                getMenuInflater().inflate(R.menu.countdown_view, menu);
                break;
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_remove) {
            CountdownsManager.getInstance().unsubscribe();
        } else if (id == R.id.action_save) {
            Countdown countdown = new Countdown();
            countdown.name = "From russian with love";
            countdown.datetime = Calendar.getInstance().getTimeInMillis();

            CountdownsManager.getInstance().postCountdown(countdown);
        }

        return true;
    }
}
