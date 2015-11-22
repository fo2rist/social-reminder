package com.weezlabs.socialreminder.activities;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
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
    private static final String NAME_KEY = "name_key";
    private static final String LOCATION_NAME_KEY = "location_name_key";
//    private static final String LATLON_KEY = "latlon_key";

    private Mode mode_ = Mode.Edit;
    private String id_ = null;
    private Calendar dateTime_ = null;

    private String name_ = null;
    private String locationName_ = null;


    //controls
    TextView date;
    EditText name;
    EditText location;
    View progressView;

    /**
     * Launch Condound View Activity for Result
     */
    public static void launchForEditing(Activity context, int requestCode) {
        Intent intent = new Intent(context, CountdownActivity.class);
        intent.putExtra(MODE_KEY, Mode.Edit);
        context.startActivityForResult(intent, requestCode);
    }

    /**
     * Launch Condound View Activity
     */
    public static void launchForViewing(Context context, Mode mode, Countdown countdown) {
        Intent intent = new Intent(context, CountdownActivity.class);
        intent.putExtra(MODE_KEY, mode);
        intent.putExtra(ID_KEY, countdown.id);
        intent.putExtra(NAME_KEY, countdown.name);
        intent.putExtra(LOCATION_NAME_KEY, countdown.locationName);
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
        progressView = findViewById(R.id.progress);

        //get parameters from bundle
        mode_ = (Mode) getIntent().getSerializableExtra(MODE_KEY);
        id_ = getIntent().getStringExtra(ID_KEY);//will be null in edit mode
        Countdown countdown = CountdownsManager.getInstance().getCountdowById(id_);
        if (countdown != null) {
            name_ = countdown.name;
            locationName_ = countdown.locationName;
        } else {
            name_ = getIntent().getStringExtra(NAME_KEY);
            locationName_ = getIntent().getStringExtra(LOCATION_NAME_KEY);
        }

        //set other parameters
        dateTime_ = Calendar.getInstance();

        //populate views
        updateViews();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.countdown_view, menu);
        // Inflate the menu; this adds items to the action bar if it is present.
        switch (mode_) {
            case Edit:
                menu.findItem(R.id.action_save).setVisible(true);
                menu.findItem(R.id.action_remove).setVisible(false);
                menu.findItem(R.id.action_subscribe).setVisible(false);
                break;
            case View:
                menu.findItem(R.id.action_save).setVisible(false);
                if (CountdownsManager.getInstance().isSubscribedTo(id_)) {
                    menu.findItem(R.id.action_remove).setVisible(true);
                    menu.findItem(R.id.action_subscribe).setVisible(false);
                } else {
                    menu.findItem(R.id.action_remove).setVisible(false);
                    menu.findItem(R.id.action_subscribe).setVisible(true);
                }
                break;
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_remove) {
            showProgress(true);
            CountdownsManager.getInstance().unsubscribe(id_).subscribe(
                    new Action1<Void>() {
                        @Override
                        public void call(Void nothing) {
                            setResult(RESULT_OK);
                            finish();
                        }
                    },
                    new Action1<Throwable>() {
                        @Override
                        public void call(Throwable throwable) {
                            showProgress(false);
                            Snackbar.make(CountdownActivity.this.name, "Shit happened", Snackbar.LENGTH_LONG).show();
                        }
                    }
            );
        } else if (id == R.id.action_subscribe) {
            showProgress(true);
            Countdown countdown = new Countdown();
            countdown.id = id_;
            CountdownsManager.getInstance().postCountdown(countdown).subscribe(
                    new Action1<Countdown>() {
                        @Override
                        public void call(Countdown countdown) {
                            setResult(RESULT_OK);
                            finish();
                        }
                    },
                    new Action1<Throwable>() {
                        @Override
                        public void call(Throwable throwable) {
                            showProgress(false);
                            Snackbar.make(CountdownActivity.this.name, "Shit happened", Snackbar.LENGTH_LONG).show();
                        }
                    }
            );
        } else if (id == R.id.action_save) {
            showProgress(true);
            Countdown countdown = new Countdown();
            countdown.setDatetime(dateTime_.getTimeInMillis());
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
                                        setResult(RESULT_OK);
                                        finish();
                                    }
                                },
                                new Action1<Throwable>() {
                                    @Override
                                    public void call(Throwable throwable) {
                                        showProgress(false);
                                        Snackbar.make(CountdownActivity.this.name, "Shit happened", Snackbar.LENGTH_LONG).show();
                                    }
                                }
                        );
            }
        }

        return true;
    }

    public void onDateTimeClicked(View view) {
        if (mode_ != Mode.Edit) {
            return;
        }
        showDatePicker();
    }

    private void updateViews() {

        updateDateTimeView(dateTime_);
        switch (mode_) {
            case Edit:
                break;
            case View:
                name.setEnabled(false);
                findViewById(R.id.name_layout).setVisibility(name_ == null ? View.INVISIBLE : View.VISIBLE);
                name.setText(name_);

                location.setEnabled(false);
                findViewById(R.id.location_layout).setVisibility(locationName_ == null ? View.INVISIBLE : View.VISIBLE);
                location.setText(locationName_);

                break;
        }
    }


    private void updateDateTimeView(Calendar dateTime) {
        date.setText(TimeUtils.convertToDateTimeString(this, dateTime, "\n"));
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
                        dateTime_.set(Calendar.SECOND, 0);
                        dateTime_.set(Calendar.MILLISECOND, 0);
                        updateDateTimeView(dateTime_);
                    }
                },
                dateTime_.get(Calendar.HOUR_OF_DAY),
                dateTime_.get(Calendar.MINUTE),
                DateFormat.is24HourFormat(this))
        .show();
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(android.R.integer.config_shortAnimTime);
            progressView.setVisibility(show ? View.VISIBLE : View.GONE);
            progressView.animate().setDuration(shortAnimTime).alpha(
                    show ? 1 : 0).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    progressView.setVisibility(show ? View.VISIBLE : View.GONE);
                }
            });
        } else {
            // The ViewPropertyAnimator APIs are not available, so simply show
            // and hide the relevant UI components.
            progressView.setVisibility(show ? View.VISIBLE : View.GONE);
        }
    }
}
