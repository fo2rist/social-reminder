package com.weezlabs.socialreminder.networklayer;

import com.weezlabs.socialreminder.models.Contact;
import com.weezlabs.socialreminder.models.Countdown;
import com.weezlabs.socialreminder.models.User;

import java.util.ArrayList;
import java.util.List;

import retrofit.Call;
import retrofit.http.Body;
import retrofit.http.DELETE;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by WeezLabs on 11/20/15.
 */
public interface CountdownsService {
    @POST("users")
    Observable<User> register(@Body User me);

    @GET("countdowns")
    Observable<List<Countdown>> getCountdowns(@Header("UID") String userid);

    @POST("countdowns")
    Observable<Countdown> postConuntdown(@Header("UID") String userid, @Body Countdown countdown);

    @DELETE("countdowns/{id}")
    Observable<Boolean> unsubscribe(@Header("UID") String userid, @Path("id") String countdownId);

    @GET("user/countdowns")
    Observable<List<Countdown>> getMyCountdowns(@Header("UID") String userid);

    @POST("contacts")
    Observable<Boolean> follow(@Header("UID") String userid, @Body ArrayList<Contact> contacts);

    @DELETE("contacts/{phonenumber}")
    Observable<Boolean> unfollow(@Header("UID") String userid, @Path("phonenumber") String phoneNumber);
}
