package com.weezlabs.socialreminder.datalayer;

import android.content.Context;
import android.util.Log;

import com.weezlabs.socialreminder.adapters.CountdownsAdapter;
import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.models.User;
import com.weezlabs.socialreminder.networklayer.CountdownsServiceBuilder;
import com.weezlabs.socialreminder.networklayer.CountdownsService;

import java.util.ArrayList;
import java.util.List;

import retrofit.Call;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class CountdownsManager {
    private static CountdownsManager ourInstance = new CountdownsManager();

    private CountdownsService countdownsService_;
    private List<Countdown> countdowns_;
    private String userId_;

    public static CountdownsManager getInstance() {
        return ourInstance;
    }

    private CountdownsManager() {
        countdownsService_ = CountdownsServiceBuilder.build("http://10.10.40.12:5000/");
        countdowns_ = new ArrayList<>();
        userId_ = "00000000-0000-0000-0000-000000000000"; //Default null ID
        /*DEBUG*/
        countdowns_.add(new Countdown("testKey", "SuperBowl", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl1", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl2", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl3", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl4", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl5", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl6", System.currentTimeMillis()));
        countdowns_.add(new Countdown("testKey", "SuperBowl7", System.currentTimeMillis()));
        /*END DEBUG*/
    }

    public CountdownsAdapter getCountdownsAdapter(Context context) {
        return new CountdownsAdapter(context, countdowns_);
    }

    /** @return null if not registered */
    public String getUserId() {
        return userId_;
    }

    public void register(User user) {
        countdownsService_.register(user);
    }

    public void getCountdowns() {
        Call<List<Countdown>> countdownsCall = countdownsService_.getCountdowns(getUserId());
        countdownsCall.enqueue(new Callback<List<Countdown>>() {
            @Override
            public void onResponse(Response<List<Countdown>> response, Retrofit retrofit) {
                Log.d("On3", "Get" + response);
            }

            @Override
            public void onFailure(Throwable t) {
                Log.d("On3", "Error");
            }
        });
        countdowns_.clear();
        countdowns_.addAll(countdowns_);
    }

    public void postCountdown(Countdown countdown) {
        countdownsService_.postConuntdown(userId_, countdown).enqueue(new Callback<Countdown>() {
            @Override
            public void onResponse(Response<Countdown> response, Retrofit retrofit) {

            }

            @Override
            public void onFailure(Throwable t) {

            }
        });
    }

    public void unsubscribe() {
        countdownsService_.unsubscribe(getUserId()).enqueue(new Callback<Boolean>() {
            @Override
            public void onResponse(Response<Boolean> response, Retrofit retrofit) {

            }

            @Override
            public void onFailure(Throwable t) {

            }
        });
    }

    public void getMyCountdowns() {
        countdownsService_.getMyCountdowns(getUserId()).enqueue(new Callback<Boolean>() {
            @Override
            public void onResponse(Response<Boolean> response, Retrofit retrofit) {

            }

            @Override
            public void onFailure(Throwable t) {

            }
        });
    }

    public void follow() {
        countdownsService_.follow(getUserId()).enqueue(new Callback<Boolean>() {
            @Override
            public void onResponse(Response<Boolean> response, Retrofit retrofit) {

            }

            @Override
            public void onFailure(Throwable t) {

            }
        });
    }

    public void unfollow() {
        countdownsService_.unfollow(getUserId()).enqueue(new Callback<Boolean>() {
            @Override
            public void onResponse(Response<Boolean> response, Retrofit retrofit) {

            }

            @Override
            public void onFailure(Throwable t) {

            }
        });
    }

}
