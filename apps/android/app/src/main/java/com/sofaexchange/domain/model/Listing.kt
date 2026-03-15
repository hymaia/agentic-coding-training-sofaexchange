package com.sofaexchange.domain.model

data class Listing(
    val id: String,
    val title: String,
    val city: City,
    val pricePerNightCents: Int,
    val sofaType: SofaType,
    val hasFreeWifi: Boolean,
    val createdAt: String,
    val updatedAt: String,
)
