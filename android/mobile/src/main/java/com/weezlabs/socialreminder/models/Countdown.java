package com.weezlabs.socialreminder.models;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class Countdown {
    public String key;
    public String name;
    public Long datetime;
//    String longlat;
//    String locationName;

    public Countdown() {

    }

    public Countdown(String key, String name, Long datetime) {
        this.key = key;
        this.name = name;
        this.datetime = datetime;
    }

}
