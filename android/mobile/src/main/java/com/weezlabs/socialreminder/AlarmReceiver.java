package com.weezlabs.socialreminder;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.weezlabs.socialreminder.activities.MainActivity;
import com.weezlabs.socialreminder.datalayer.CountdownsManager;
import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.utils.TimeUtils;

/**
 * Created by WeezLabs on 11/22/15.
 */
public class AlarmReceiver extends BroadcastReceiver {
    private static final int NOTFICATION_ID = 1;

    @Override
    public void onReceive(Context context, Intent intent) {
        String countdownId = intent.getStringExtra(CountdownsManager.COUNTDOWN_ID_KEY);
        if (countdownId == null) {
            return;
        }

        Countdown countdown = CountdownsManager.getInstance().getCountdownById(countdownId);
        if (countdown == null) {
            return;
        }

        showNotification(context, countdown);
    }

    private void showNotification(Context context, Countdown countdown) {
        Uri alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder notificaitonBuilder =
                new NotificationCompat.Builder(context)
                        .setSmallIcon(R.drawable.ic_on3)
                        .setContentTitle(countdown.name)
                        .setContentText("At " + TimeUtils.convertToDateTimeString(context, countdown.getDatetime(), " "))
                        .setSound(alarmSound);
        // Creates an explicit intent for an Activity in your app
        Intent resultIntent = new Intent(context, MainActivity.class);


        PendingIntent resultPendingIntent = PendingIntent.getActivity(
                        context,
                        0,
                        resultIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT);
        notificaitonBuilder.setContentIntent(resultPendingIntent);
        NotificationManager mNotificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        mNotificationManager.notify(NOTFICATION_ID, notificaitonBuilder.build());
    }
}
