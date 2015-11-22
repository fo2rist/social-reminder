package com.weezlabs.socialreminder.adapters;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.CountDownTimer;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.weezlabs.socialreminder.R;
import com.weezlabs.socialreminder.activities.CountdownActivity;
import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.utils.TimeUtils;

import java.util.List;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class CountdownsAdapter extends RecyclerView.Adapter<CountdownsAdapter.CountdownViewHolder> {


    public static class CountdownViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        protected Countdown countdown;

        protected View cardHeader;
        protected TextView countdownTimer;
        protected TextView name;
        protected TextView details;

        protected CountDownTimer timer = null;

        public CountdownViewHolder(View itemView) {
            super(itemView);
            cardHeader = itemView.findViewById(R.id.card_header);
            countdownTimer = (TextView) itemView.findViewById(R.id.countdown_timer);
            name = (TextView) itemView.findViewById(R.id.name);
            details = (TextView) itemView.findViewById(R.id.details);

            itemView.setOnClickListener(this);
        }

        public void startTimer(Countdown countdownData) {
            if (timer != null) {
                timer.cancel();
            }

            timer = new CountDownTimer(countdownData.getDatetime() - System.currentTimeMillis(), 1000) {

                public void onTick(long millisUntilFinished) {
                    countdownTimer.setText(TimeUtils.convertToInterval(millisUntilFinished));
                }

                public void onFinish() {
                }
            }.start();
        }

        @Override
        public void onClick(View v) {
            CountdownActivity.launchForViewing(v.getContext(), CountdownActivity.Mode.View, countdown);
        }
    }


    private static String[] sColorsArray;

    private final Context context_;
    private final List<Countdown> countdowns_;

    private static int getCardColor(Context context, String countdownId) {
        if (sColorsArray == null) {
            sColorsArray = context.getResources().getStringArray(R.array.cardsColors);
        }
        int index = Math.abs(countdownId.hashCode() % sColorsArray.length);
        return Color.parseColor(sColorsArray[index]);
    }

    public CountdownsAdapter(Context context, List<Countdown> countdowns) {
        context_ = context;
        countdowns_ = countdowns;
    }

    @Override
    public CountdownViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View result = LayoutInflater
                .from(parent.getContext())
                .inflate(R.layout.coundown_card, parent, false);
        CountdownViewHolder holder = new CountdownViewHolder(result);
        holder.name.setShadowLayer(20, 0, 0, context_.getResources().getColor(android.R.color.primary_text_light));
        return holder;
    }

    @Override
    public void onBindViewHolder(CountdownViewHolder holder, int position) {
        Countdown countdownData = countdowns_.get(position);
        holder.countdown = countdownData;

        holder.name.setText(countdownData.name);
        holder.countdownTimer.setText(
                TimeUtils.convertToInterval(countdownData.getDatetime() - System.currentTimeMillis())
        );
        String detailsText = "On " +
                TimeUtils.convertToDateTimeString(context_, countdownData.getDatetime(), " ");
        if (countdownData.locationName != null && !countdownData.locationName.isEmpty()) {
            detailsText += " at " + countdownData.locationName;
        }
        holder.details.setText(detailsText);

        Drawable easterBackground = getEasterBackground(countdownData.name);
        if (easterBackground != null) {
            holder.cardHeader.setBackground(easterBackground);
        } else {
            holder.cardHeader.setBackgroundColor(CountdownsAdapter.getCardColor(context_, countdownData.key));
        }

        holder.startTimer(countdownData);
    }

    @Override
    public int getItemCount() {
        return countdowns_.size();
    }

    private Drawable getEasterBackground(String name) {
        String lowerName = name.toLowerCase();
        if (lowerName.contains("вмф")) {
            return context_.getResources().getDrawable(R.drawable.flag_vmf, null);
        } else if (lowerName.contains("вдв")) {
            return context_.getResources().getDrawable(R.drawable.flag_troops, null);
        } else if (lowerName.contains("росси")) {
            return context_.getResources().getDrawable(R.drawable.flag_rf, null);
        } else if (lowerName.contains("картош") || lowerName.contains("картоф") || lowerName.contains("картох")) {
            return context_.getResources().getDrawable(R.drawable.flag_belarus, null);
        }

        return null;
    }
}
