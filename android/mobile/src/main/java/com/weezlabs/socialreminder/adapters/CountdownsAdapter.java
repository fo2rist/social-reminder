package com.weezlabs.socialreminder.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.weezlabs.socialreminder.R;
import com.weezlabs.socialreminder.models.Countdown;

import java.util.List;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class CountdownsAdapter extends RecyclerView.Adapter<CountdownsAdapter.CountdownViewHolder> {
    private final Context context_;
    private final List<Countdown> countdowns_;

    public static class CountdownViewHolder extends RecyclerView.ViewHolder {
        protected TextView countdownTimer;
        protected TextView date;
        protected TextView location;

        public CountdownViewHolder(View itemView) {
            super(itemView);
            countdownTimer = (TextView) itemView.findViewById(R.id.countdown_timer);
            date = (TextView) itemView.findViewById(R.id.date);
            location = (TextView) itemView.findViewById(R.id.location);
        }
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
        return new CountdownViewHolder(result);
    }

    @Override
    public void onBindViewHolder(CountdownViewHolder holder, int position) {
        Countdown countdownData = countdowns_.get(position);

        holder.countdownTimer.setText("");
        holder.date.setText("" + countdownData.datetime);
        holder.location.setText(countdownData.key);
    }

    @Override
    public int getItemCount() {
        return countdowns_.size();
    }
}
