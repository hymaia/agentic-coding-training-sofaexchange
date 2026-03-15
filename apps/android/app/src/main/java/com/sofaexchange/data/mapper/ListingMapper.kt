package com.sofaexchange.data.mapper

import com.sofaexchange.data.remote.ListingDto
import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.model.SofaType

object ListingMapper {
    fun toDomain(dto: ListingDto): Listing? {
        val city = City.fromApiValue(dto.city) ?: return null
        val sofaType = SofaType.fromApiValue(dto.sofaType) ?: return null
        return Listing(
            id = dto.id,
            title = dto.title,
            city = city,
            pricePerNightCents = dto.pricePerNightCents,
            sofaType = sofaType,
            hasFreeWifi = dto.hasFreeWifi,
            createdAt = dto.createdAt,
            updatedAt = dto.updatedAt,
        )
    }
}
