package com.weezlabs.socialreminder.datalayer;

import android.content.Context;
import android.content.SharedPreferences;
import android.support.annotation.Nullable;

import com.weezlabs.socialreminder.adapters.CountdownsAdapter;
import com.weezlabs.socialreminder.models.Contact;
import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.models.User;
import com.weezlabs.socialreminder.networklayer.CountdownsServiceBuilder;
import com.weezlabs.socialreminder.networklayer.CountdownsService;

import java.util.ArrayList;
import java.util.List;

import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
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

    private static final String SHARED_PREFS_KEY = "On3";
    private static final String UID_PREFS_KEY = "uid";


    private static final String NULL_GUID = "00000000-0000-0000-0000-000000000000";
    private String uid_ = "";

    public static CountdownsManager getInstance() {
        return ourInstance;
    }

    private CountdownsManager() {
        countdownsService_ = CountdownsServiceBuilder.build("http://10.10.40.12:5000/");
        countdowns_ = new ArrayList<>();
    }

    public CountdownsAdapter getMyCountdownsAdapter(Context context) {
        if (countdownsAdapter_ == null) {
            countdownsAdapter_ = new CountdownsAdapter(context, countdowns_);
        }
        return countdownsAdapter_;
    }

    public void restore(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(SHARED_PREFS_KEY, Context.MODE_PRIVATE);
        uid_ = preferences.getString(UID_PREFS_KEY, "");
    }

    public void save(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(SHARED_PREFS_KEY, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(UID_PREFS_KEY, uid_);
        editor.commit();
    }

    /** @return empty string if not registered */
    public String getUserId() {
        return uid_;
    }

    public void logout(Context context) {
        uid_ = "";
        countdowns_.clear();
        countdownsAdapter_ = null;
        save(context);
    }

    @Nullable
    public Countdown getCountdowById(String id) {
        for (Countdown countdown: countdowns_) {
            if (countdown.id.equals(id)) {
                return countdown;
            }
        }

        return null;
    }

    public boolean isSubscribedTo(String id) {
        return (getCountdowById(id) != null);
    }

    public Observable<User> register(User user) {
        return countdownsService_.register(user)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<User, User>() {
                    @Override
                    public User call(User user) {
                        uid_ = user.uid;
                        return user;
                    }
                });
    }

    public Observable<List<Countdown>> updateMyCountdowns() {
        return getMyCountdowns().map(
                new Func1<List<Countdown>, List<Countdown>>() {
                    @Override
                    public List<Countdown> call(List<Countdown> countdowns) {
                        countdowns_.clear();
                        countdowns_.addAll(countdowns);
                        countdownsAdapter_.notifyDataSetChanged();
                        return countdowns;
                    }
                }
        );
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
        Observable<Countdown> countdownObservable = countdownsService_.postConuntdown(uid_, countdown);
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

    public Observable<Void> unsubscribe(String countdownId) {
        return countdownsService_.unsubscribe(getUserId(), countdownId)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<Void, Void>() {
                    @Override
                    public Void call(Void nothing) {
                        updateMyCountdowns();
                        return nothing;
                    }
                });
    }

    public Observable<Boolean> follow(ArrayList<Contact> contacts) {
        return countdownsService_.follow(getUserId(), contacts)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<Boolean> unfollow(String phoneNumber) {
        return countdownsService_.unfollow(getUserId(), phoneNumber)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

}
