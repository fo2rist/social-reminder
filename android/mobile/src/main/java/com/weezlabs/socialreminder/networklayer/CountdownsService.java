package com.weezlabs.socialreminder.networklayer;

import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.models.User;

import java.util.List;

import retrofit.Call;
import retrofit.http.Body;
import retrofit.http.DELETE;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.POST;

/**
 * Created by WeezLabs on 11/20/15.
 */
public interface CountdownsService {
    @POST("users")
    Call<User> register(@Body User me);

    @GET("countdowns")
    Call<List<Countdown>> getCountdowns(@Header("UID") String userid);

    @POST("countdowns")
    Call<Countdown> postConuntdown(@Header("UID") String userid, @Body Countdown countdown);

    @DELETE("countdowns/%id")
    Call<Boolean> unsubscribe(@Header("UID") String userid);

    @GET("user/countdowns")
    Call<Boolean> getMyCountdowns(@Header("UID") String userid);

    @POST("contacts")
    Call<Boolean> follow(@Header("UID") String userid);

    @DELETE("contacts/%phonenumber")
    Call<Boolean> unfollow(@Header("UID") String userid);
}
