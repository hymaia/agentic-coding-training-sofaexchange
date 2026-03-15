package com.sofaexchange.data.mapper

import com.sofaexchange.data.remote.ListingDto
import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.SofaType
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Test

class ListingMapperTest {

    private val validDto = ListingDto(
        id                 = "550e8400-e29b-41d4-a716-446655440000",
        title              = "Cozy sofa bed in central London",
        city               = "LONDON",
        pricePerNightCents = 4500,
        sofaType           = "SOFA_BED",
        hasFreeWifi        = true,
        createdAt          = "2024-01-01T00:00:00Z",
        updatedAt          = "2024-01-01T00:00:00Z",
    )

    @Test
    fun `toDomain with valid DTO returns correct Listing`() {
        val result = ListingMapper.toDomain(validDto)

        assertNotNull(result)
        assertEquals(validDto.id, result!!.id)
        assertEquals(validDto.title, result.title)
        assertEquals(City.LONDON, result.city)
        assertEquals(validDto.pricePerNightCents, result.pricePerNightCents)
        assertEquals(SofaType.SOFA_BED, result.sofaType)
        assertEquals(validDto.hasFreeWifi, result.hasFreeWifi)
        assertEquals(validDto.createdAt, result.createdAt)
        assertEquals(validDto.updatedAt, result.updatedAt)
    }

    @Test
    fun `toDomain with unknown city returns null`() {
        val dto = validDto.copy(city = "UNKNOWN_CITY")

        val result = ListingMapper.toDomain(dto)

        assertNull(result)
    }

    @Test
    fun `toDomain with unknown sofaType returns null`() {
        val dto = validDto.copy(sofaType = "HAMMOCK")

        val result = ListingMapper.toDomain(dto)

        assertNull(result)
    }

    @Test
    fun `toDomain with SIMPLE_SOFA type maps correctly`() {
        val dto = validDto.copy(sofaType = "SIMPLE_SOFA", city = "PARIS")

        val result = ListingMapper.toDomain(dto)

        assertNotNull(result)
        assertEquals(SofaType.SIMPLE_SOFA, result!!.sofaType)
        assertEquals(City.PARIS, result.city)
    }
}
