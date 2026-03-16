package com.sofaexchange.data.remote

import retrofit2.http.GET
import retrofit2.http.Query

interface ListingsApi {
    @GET("listings")
    suspend fun getListings(
        @Query("city")        city: List<String>?,
        @Query("hasFreeWifi") hasFreeWifi: Boolean?,
        @Query("sofaType")    sofaType: String?,
    ): List<ListingDto>
}
