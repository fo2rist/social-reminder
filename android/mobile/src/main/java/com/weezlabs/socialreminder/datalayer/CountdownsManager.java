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
import rx.Observable;
import rx.Scheduler;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class CountdownsManager {
    private static CountdownsManager ourInstance = new CountdownsManager();

    private CountdownsService countdownsService_;

    private List<Countdown> countdowns_ = null;
    CountdownsAdapter countdownsAdapter_ = null;

    private String userId_;

    public static CountdownsManager getInstance() {
        return ourInstance;
    }

    private CountdownsManager() {
        countdownsService_ = CountdownsServiceBuilder.build("http://10.10.40.12:5000/");
        countdowns_ = new ArrayList<>();
        userId_ = "00000000-0000-0000-0000-000000000000"; //Default null ID
    }

    public CountdownsAdapter getMyCountdownsAdapter(Context context) {
        if (countdownsAdapter_ == null) {
            countdownsAdapter_ = new CountdownsAdapter(context, countdowns_);
        }
        return countdownsAdapter_;
    }

    /** @return null if not registered */
    public String getUserId() {
        return userId_;
    }

    public Observable<User> register(User user) {
        return countdownsService_.register(user)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public void updateMyCountdowns() {
        getMyCountdowns().subscribe(
                new Action1<List<Countdown>>() {
                    @Override
                    public void call(List<Countdown> countdowns) {
                        countdowns_.clear();
                        countdowns_.addAll(countdowns);
                        countdownsAdapter_.notifyDataSetChanged();
                    }
                },
                new Action1<Throwable>() {
                    @Override
                    public void call(Throwable throwable) {
                        Log.d("On3", "Shit happened");
                    }
                });
    }

    public Observable<List<Countdown>> getMyCountdowns() {
        return countdownsService_.getMyCountdowns(getUserId())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<List<Countdown>> getCountdowns() {
        Observable<List<Countdown>> countdownsCall = countdownsService_.getCountdowns(getUserId());
        return countdownsCall
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<Countdown> postCountdown(Countdown countdown) {
        Observable<Countdown> countdownObservable = countdownsService_.postConuntdown(userId_, countdown);
        return countdownObservable
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<Countdown, Countdown>() {
                    @Override
                    public Countdown call(Countdown countdown) {
                        updateMyCountdowns();
                        return countdown;
                    }
                });
    }

    public Observable<Boolean> unsubscribe() {
        return countdownsService_.unsubscribe(getUserId())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<Boolean> follow() {
        return countdownsService_.follow(getUserId())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<Boolean> unfollow() {
        return countdownsService_.unfollow(getUserId())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

}
