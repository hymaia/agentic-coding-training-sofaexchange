package com.sofaexchange.domain.usecase

import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.model.SofaType
import com.sofaexchange.domain.repository.ListingsRepository
import com.sofaexchange.domain.repository.SearchParams
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Test
import org.mockito.kotlin.mock
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

class SearchListingsUseCaseTest {

    private val repository: ListingsRepository = mock()
    private val useCase = SearchListingsUseCase(repository)

    private val sampleListing = Listing(
        id                 = "abc-123",
        title              = "Cozy sofa in London",
        city               = City.LONDON,
        pricePerNightCents = 3500,
        sofaType           = SofaType.SOFA_BED,
        hasFreeWifi        = true,
        createdAt          = "2024-01-01T00:00:00Z",
        updatedAt          = "2024-01-01T00:00:00Z",
    )

    @Test
    fun `execute delegates to repository and returns its result`() = runBlocking {
        val params = SearchParams(cities = listOf(City.LONDON))
        whenever(repository.search(params)).thenReturn(listOf(sampleListing))

        val result = useCase.execute(params)

        verify(repository).search(params)
        assertEquals(listOf(sampleListing), result)
    }

    @Test
    fun `execute returns empty list when repository returns empty`() = runBlocking {
        val params = SearchParams()
        whenever(repository.search(params)).thenReturn(emptyList())

        val result = useCase.execute(params)

        verify(repository).search(params)
        assertEquals(emptyList<Listing>(), result)
    }
}
