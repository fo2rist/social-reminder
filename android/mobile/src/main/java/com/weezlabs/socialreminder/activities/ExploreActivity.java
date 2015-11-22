package com.weezlabs.socialreminder.activities;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.os.Build;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.design.widget.TabLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;

import com.weezlabs.socialreminder.R;
import com.weezlabs.socialreminder.adapters.CountdownsAdapter;
import com.weezlabs.socialreminder.datalayer.CountdownsManager;
import com.weezlabs.socialreminder.models.Countdown;

import java.util.List;

import rx.functions.Action1;

public class ExploreActivity extends AppCompatActivity implements TabLayout.OnTabSelectedListener {

    private RecyclerView countdownsList;
    private View progressView;
    private TabLayout tabs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_explore);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        //setup controls
        progressView = findViewById(R.id.progress);
        countdownsList = (RecyclerView) findViewById(R.id.countdowns_list);
        tabs = (TabLayout) findViewById(R.id.tabs);
        LinearLayoutManager llm = new LinearLayoutManager(this);
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        countdownsList.setLayoutManager(llm);

        tabs.addTab(tabs.newTab().setText("Top countdowns"));
        tabs.addTab(tabs.newTab().setText("Friends"));
        tabs.setOnTabSelectedListener(this);

        //start data loading
        startDataLoading(CountdownsManager.Filter.Popular);
    }

    private void startDataLoading(CountdownsManager.Filter mode) {
        showProgress(true);
        CountdownsManager.getInstance().getCountdowns(mode).subscribe(
                new Action1<List<Countdown>>() {
                    @Override
                    public void call(List<Countdown> countdowns) {
                        setData(countdowns);
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

    private void setData(List<Countdown> countdowns) {
        CountdownsAdapter adapter = new CountdownsAdapter(this, countdowns);
        countdownsList.setAdapter(adapter);
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

    @Override
    public void onTabSelected(TabLayout.Tab tab) {
        switch(tabs.getSelectedTabPosition()) {
            case 0:
                startDataLoading(CountdownsManager.Filter.Popular);
                break;
            case 1:
                startDataLoading(CountdownsManager.Filter.Friends);
                break;
        }
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab) {
    }

    @Override
    public void onTabReselected(TabLayout.Tab tab) {
    }
}
