package com.sofaexchange.domain.usecase

import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.repository.ListingsRepository
import com.sofaexchange.domain.repository.SearchParams

class SearchListingsUseCase(private val repository: ListingsRepository) {
    suspend fun execute(params: SearchParams): List<Listing> = repository.search(params)
}
