package com.sofaexchange.presentation.search

import androidx.lifecycle.ViewModel
import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.SofaType
import com.sofaexchange.domain.repository.SearchParams

class SearchViewModel : ViewModel() {
    var selectedCities: MutableList<City> = mutableListOf()
    var minPriceCents: Int? = null
    var maxPriceCents: Int? = null
    var hasFreeWifi: Boolean? = null
    var selectedSofaType: SofaType? = null

    fun buildSearchParams() = SearchParams(
        cities        = selectedCities.toList(),
        minPriceCents = minPriceCents,
        maxPriceCents = maxPriceCents,
        hasFreeWifi   = hasFreeWifi,
        sofaType      = selectedSofaType,
    )
}
