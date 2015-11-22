package com.weezlabs.socialreminder.activities;

import android.accounts.Account;
import android.accounts.AccountManager;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.weezlabs.socialreminder.R;
import com.weezlabs.socialreminder.datalayer.CountdownsManager;
import com.weezlabs.socialreminder.models.Countdown;

import java.util.LinkedList;
import java.util.List;

import rx.functions.Action1;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private static final int CREATE_COUNTDOWN_REQUEST = 100;
    private static final int EXPLORE_REUQEST = 101;

    private RecyclerView countdownsList;
    private View progressView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        CountdownsManager.getInstance().restore(this);
        if (CountdownsManager.getInstance().getUserId().isEmpty()) {
            startActivity(new Intent(this, LoginActivity.class));
            finish();
            return;
        }

        setContentView(R.layout.activity_main);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //setup controls
        progressView = findViewById(R.id.progress);
        countdownsList = (RecyclerView) findViewById(R.id.countdowns_list);

        //setup left menu
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //setup countdowns list
        LinearLayoutManager llm = new LinearLayoutManager(this);
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        countdownsList.setLayoutManager(llm);
        countdownsList.setAdapter(CountdownsManager.getInstance().getMyCountdownsAdapter(this));

    }

    @Override
    protected void onResume() {
        super.onResume();
        //initialize data loading
        updateMyCountdowns();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // Check which request we're responding to
        if (requestCode == CREATE_COUNTDOWN_REQUEST) {
            // Make sure the request was successful
            if (resultCode == RESULT_OK) {
                updateMyCountdowns();
            }
        } else if (requestCode == EXPLORE_REUQEST) {
            updateMyCountdowns();
        }
    }

    private void updateMyCountdowns() {
        showProgress(true);
        CountdownsManager.getInstance().updateMyCountdowns()
                .subscribe(
                        new Action1<List<Countdown>>() {
                            @Override
                            public void call(List<Countdown> countdowns) {
                                showProgress(false);
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                showProgress(false);
                                Snackbar.make(countdownsList, "Unable to load countdowns", Snackbar.LENGTH_LONG).show();
                            }
                        }
                );
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);

        //Update info on drawer
        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        TextView navTitle = (TextView) navigationView.findViewById(R.id.nav_header_title);
        TextView navDetails = (TextView) navigationView.findViewById(R.id.nav_header_details);
        navTitle.setText(getUsername());
        navDetails.setText(getPossibleEmails().get(0));

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_explore) {
            startActivityForResult(new Intent(this, ExploreActivity.class), EXPLORE_REUQEST);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_refresh) {
            updateMyCountdowns();
        } else if (id == R.id.nav_tell_friends) {
            Snackbar.make(countdownsList, "Hi friends! Here is the best countdown app.", Snackbar.LENGTH_LONG).show();
        } else if (id == R.id.nav_settings) {

        } else if (id == R.id.nav_logout) {
            CountdownsManager.getInstance().logout(this);
            startActivity(new Intent(this, LoginActivity.class));
            finish();
        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    public void onAddCountdownClick(View view) {
        CountdownActivity.launchForEditing(this, CREATE_COUNTDOWN_REQUEST);
    }

    @NonNull
    public String getUsername() {
        List<String> possibleEmails = getPossibleEmails();

        if (!possibleEmails.isEmpty() && possibleEmails.get(0) != null) {
            String email = possibleEmails.get(0);
            String[] parts = email.split("@");

            if (parts.length > 1)
                return parts[0];
        }
        return "";
    }

    @NonNull
    private List<String> getPossibleEmails() {
        AccountManager manager = AccountManager.get(this);
        Account[] accounts = manager.getAccountsByType("com.google");
        List<String> possibleEmails = new LinkedList<String>();

        for (Account account : accounts) {
            // TODO: Check possibleEmail against an email regex or treat
            // account.name as an email address only for certain account.type values.
            possibleEmails.add(account.name);
        }
        return possibleEmails;
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(android.R.integer.config_shortAnimTime);

            countdownsList.setVisibility(show ? View.GONE : View.VISIBLE);
            countdownsList.animate().setDuration(shortAnimTime).alpha(
                    show ? 0 : 1).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    countdownsList.setVisibility(show ? View.GONE : View.VISIBLE);
                }
            });

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
            countdownsList.setVisibility(show ? View.GONE : View.VISIBLE);
        }
    }
}
