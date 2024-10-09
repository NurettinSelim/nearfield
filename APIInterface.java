// ApiService.java
package com.example.phonemobileapp.network;

import com.example.phonemobileapp.model.Record;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.PUT;
import retrofit2.http.DELETE;

import java.util.List;

public interface ApiService {
    @POST("api/records")
    Call<Record> createRecord(@Body Record record);

    @GET("api/records")
    Call<List<Record>> getAllRecords();

    @GET("api/records/{id}")
    Call<Record> getRecordById(@Path("id") Long id);

    @PUT("api/records/{id}")
    Call<Record> updateRecord(@Path("id") Long id, @Body Record record);

    @DELETE("api/records/{id}")
    Call<Void> deleteRecord(@Path("id") Long id);
}
