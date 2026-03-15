package com.sofaexchange.data.remote

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ListingDto(
    @Json(name = "id")                 val id: String,
    @Json(name = "title")              val title: String,
    @Json(name = "city")               val city: String,
    @Json(name = "pricePerNightCents") val pricePerNightCents: Int,
    @Json(name = "sofaType")           val sofaType: String,
    @Json(name = "hasFreeWifi")        val hasFreeWifi: Boolean,
    @Json(name = "createdAt")          val createdAt: String,
    @Json(name = "updatedAt")          val updatedAt: String,
)
