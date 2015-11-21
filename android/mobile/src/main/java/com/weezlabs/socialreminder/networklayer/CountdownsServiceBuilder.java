package com.weezlabs.socialreminder.networklayer;

import android.util.Log;

import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;
import com.squareup.okhttp.ResponseBody;

import java.io.IOException;

import okio.Buffer;
import retrofit.GsonConverterFactory;
import retrofit.Retrofit;
import retrofit.RxJavaCallAdapterFactory;

/**
 * Created by WeezLabs on 11/20/15.
 */
public class CountdownsServiceBuilder {

    public static class LoggingInterceptor implements Interceptor {
        @Override
        public Response intercept(Chain chain) throws IOException {
            Request request = chain.request();
            long t1 = System.nanoTime();
            String requestLog = String.format("Sending request %s on %s%n%s",
                    request.url(), 
                    chain.connection(), 
                    request.headers());
            
            if(request.method().compareToIgnoreCase("post")==0){
                requestLog = requestLog + "\n" + bodyToString(request);
            }
            Log.d("On3", requestLog);

            Response response = chain.proceed(request);
            long t2 = System.nanoTime();
            String responseLog = String.format("Received response for %s in %.1fms%n%s",
                    response.request().url(),
                    (t2 - t1) / 1e6d,
                    response.headers());

            String bodyString = response.body().string();
            Log.d("On3", responseLog + "\n" + bodyString);

            return response.newBuilder()
                    .body(ResponseBody.create(response.body().contentType(), bodyString))
                    .build();
        }
    }

    public static String bodyToString(final Request request) {
        try {
            final Request copy = request.newBuilder().build();
            final Buffer buffer = new Buffer();
            copy.body().writeTo(buffer);
            return buffer.readUtf8();
        } catch (final IOException e) {
            return "did not work";
        }
    }

    public static CountdownsService build(String baseUrl) {
        OkHttpClient client = new OkHttpClient();
        client.interceptors().add(new LoggingInterceptor());

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(baseUrl)
                .addConverterFactory(GsonConverterFactory.create())
                .client(client)
                .build();
        return retrofit.create(CountdownsService.class);
    }
}
