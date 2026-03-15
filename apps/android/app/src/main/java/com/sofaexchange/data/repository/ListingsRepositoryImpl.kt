package com.sofaexchange.data.repository

import com.sofaexchange.data.mapper.ListingMapper
import com.sofaexchange.data.remote.ListingsApi
import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.repository.ListingsRepository
import com.sofaexchange.domain.repository.SearchParams

class ListingsRepositoryImpl(
    private val api: ListingsApi,
) : ListingsRepository {

    override suspend fun search(params: SearchParams): List<Listing> {
        val dtos = api.getListings(
            city          = params.cities.map { it.name }.takeIf { it.isNotEmpty() },
            minPriceCents = params.minPriceCents,
            maxPriceCents = params.maxPriceCents,
            hasFreeWifi   = params.hasFreeWifi,
            sofaType      = params.sofaType?.name,
        )
        return dtos.mapNotNull(ListingMapper::toDomain)
    }
}
