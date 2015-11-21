package com.weezlabs.socialreminder.activities;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.format.DateFormat;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;

import com.weezlabs.socialreminder.R;
import com.weezlabs.socialreminder.datalayer.CountdownsManager;
import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.utils.TimeUtils;

import java.util.Calendar;

import rx.functions.Action1;

public class CountdownActivity extends AppCompatActivity {

    public enum Mode {
        Edit,
        View
    }

    private static final String MODE_KEY = "mode_key";
    private static final String ID_KEY = "id_key";

    private Mode mode_;
    private String id_;
    private Calendar dateTime_;

    //controls
    TextView date;
    EditText name;
    EditText location;

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

        //get views
        date = (TextView) findViewById(R.id.date);
        name = (EditText) findViewById(R.id.name);
        location = (EditText) findViewById(R.id.location);

        //get parameters from bundle
        mode_ = (Mode) getIntent().getSerializableExtra(MODE_KEY);
        id_ = getIntent().getStringExtra(ID_KEY);
        //set other parameters
        dateTime_ = Calendar.getInstance();

        //populate views
        updateDateView(dateTime_);
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
            countdown.datetime = dateTime_.getTimeInMillis();
            countdown.name = this.name.getText().toString();
            countdown.locationName = this.location.getText().toString();

            if (countdown.name.isEmpty()) {
                Snackbar.make(this.name, "Please set the name", Snackbar.LENGTH_LONG).show();
            } else {
                CountdownsManager.getInstance()
                        .postCountdown(countdown)
                        .subscribe(
                                new Action1<Countdown>() {
                                    @Override
                                    public void call(Countdown countdown) {
                                        finish();
                                    }
                                },
                                new Action1<Throwable>() {
                                    @Override
                                    public void call(Throwable throwable) {
                                        Snackbar.make(CountdownActivity.this.name, "Shit happened", Snackbar.LENGTH_LONG).show();
                                    }
                                }
                        );
            }
        }

        return true;
    }

    public void onDateTimeClicked(View view) {
        showDatePicker();
    }

    private void updateDateView(Calendar dateTime) {
        date.setText(TimeUtils.convertToDateTimeString(this, dateTime));
    }

    private void showDatePicker() {
        new DatePickerDialog(this,
                new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                        dateTime_.set(Calendar.YEAR, year);
                        dateTime_.set(Calendar.MONTH, monthOfYear);
                        dateTime_.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                        showTimePicker();
                    }
                },
                dateTime_.get(Calendar.YEAR),
                dateTime_.get(Calendar.MONTH),
                dateTime_.get(Calendar.DAY_OF_MONTH))
                .show();
    }

    private void showTimePicker() {
        new TimePickerDialog(this,
                new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        dateTime_.set(Calendar.HOUR_OF_DAY, hourOfDay);
                        dateTime_.set(Calendar.MINUTE, minute);

                        updateDateView(dateTime_);
                    }
                },
                dateTime_.get(Calendar.HOUR_OF_DAY),
                dateTime_.get(Calendar.MINUTE),
                DateFormat.is24HourFormat(this))
        .show();
    }
}
