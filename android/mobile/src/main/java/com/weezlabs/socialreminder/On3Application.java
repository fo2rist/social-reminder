package com.weezlabs.socialreminder;

import android.app.Application;

import com.weezlabs.socialreminder.datalayer.CountdownsManager;

/**
 * Created by WeezLabs on 11/22/15.
 */
public class On3Application extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        CountdownsManager.getInstance().initialize(this);
    }
}
