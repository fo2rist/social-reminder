package com.weezlabs.socialreminder.activities;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
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

public class ExploreActivity extends AppCompatActivity {

    private RecyclerView countdownsList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_explore);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //setup controls
        countdownsList = (RecyclerView) findViewById(R.id.countdowns_list);
        LinearLayoutManager llm = new LinearLayoutManager(this);
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        countdownsList.setLayoutManager(llm);

        //start data loading
        CountdownsManager.getInstance().getCountdowns().subscribe(
                new Action1<List<Countdown>>() {
                    @Override
                    public void call(List<Countdown> countdowns) {
                        setData(countdowns);
                    }
                },
                new Action1<Throwable>() {
                    @Override
                    public void call(Throwable throwable) {

                    }
                }
        );
    }

    private void setData(List<Countdown> countdowns) {
        CountdownsAdapter adapter = new CountdownsAdapter(this, countdowns);
        countdownsList.setAdapter(adapter);
    }

}
