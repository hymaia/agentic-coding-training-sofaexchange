package com.sofaexchange.domain.repository

import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.model.SofaType

data class SearchParams(
    val cities: List<City> = emptyList(),
    val minPriceCents: Int? = null,
    val maxPriceCents: Int? = null,
    val hasFreeWifi: Boolean? = null,
    val sofaType: SofaType? = null,
)

interface ListingsRepository {
    suspend fun search(params: SearchParams): List<Listing>
}
