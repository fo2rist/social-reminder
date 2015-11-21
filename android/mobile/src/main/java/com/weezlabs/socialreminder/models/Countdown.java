package com.weezlabs.socialreminder.models;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class Countdown {
    public String key;
    public String name;
    private Long datetime;
    public String longlat;
    public String locationName;

    public Countdown() {

    }

    public Countdown(String key, String name, Long datetimeMillis) {
        this.key = key;
        this.name = name;
        this.setDatetime(datetimeMillis);
    }

    public long getDatetime() {
        return datetime * 1000;
    }

    public void setDatetime(Long datetimeMillis) {
        this.datetime = datetimeMillis / 1000;
    }
}
