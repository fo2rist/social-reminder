package com.weezlabs.socialreminder.utils;

import android.content.Context;
import android.text.format.DateFormat;
import android.text.format.DateUtils;

import java.util.Calendar;

/**
 * Created by WeezLabs on 11/21/15.
 */
public class TimeUtils {

    public static String convertToInterval(long millisInterval) {
        int days = 0;
        int hours = 0;
        int minutes = 0;
        int seconds = 0;
        String stringInterval = "";

        if(millisInterval > DateUtils.DAY_IN_MILLIS)
        {
            days = (int) (millisInterval / DateUtils.DAY_IN_MILLIS);
            stringInterval += days+"d";
        }

        millisInterval -= (days*DateUtils.DAY_IN_MILLIS);

        if(millisInterval > DateUtils.HOUR_IN_MILLIS)
        {
            hours = (int) (millisInterval / DateUtils.HOUR_IN_MILLIS);
        }

        millisInterval -= (hours*DateUtils.HOUR_IN_MILLIS);

        if(millisInterval > DateUtils.MINUTE_IN_MILLIS)
        {
            minutes = (int) (millisInterval / DateUtils.MINUTE_IN_MILLIS);
        }

        millisInterval -= (minutes*DateUtils.MINUTE_IN_MILLIS);

        if(millisInterval > DateUtils.SECOND_IN_MILLIS)
        {
            seconds = (int) (millisInterval / DateUtils.SECOND_IN_MILLIS);
        }

        stringInterval += " "+String.format("%02d",hours)+":"+String.format("%02d",minutes)+":"+String.format("%02d",seconds);

        return stringInterval.trim();
    }

    public static String convertToDateTimeString(Context context, Calendar dateTime, String separator) {
        return DateFormat.getDateFormat(context).format( dateTime.getTimeInMillis() )
                + separator
                + DateFormat.getTimeFormat(context).format( dateTime.getTimeInMillis() );
    }

    public static String convertToDateTimeString(Context context, long milliseconds, String separator) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(milliseconds);
        return convertToDateTimeString(context, calendar, separator);
    }
}
