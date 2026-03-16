package com.sofaexchange.presentation.results

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.sofaexchange.data.remote.ListingDto
import com.sofaexchange.data.remote.ListingsApi
import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.model.SofaType
import com.sofaexchange.domain.repository.SearchParams
import kotlinx.coroutines.launch

class ResultsViewModel(
    private val api: ListingsApi,
) : ViewModel() {

    sealed class UiState {
        object Loading : UiState()
        data class Success(val listings: List<Listing>) : UiState()
        data class Error(val message: String, val isConnectionError: Boolean = false) : UiState()
    }

    private val _state = MutableLiveData<UiState>()
    val state: LiveData<UiState> = _state
    private val searchInput = MutableLiveData<SearchParams>()
    private val stagedParams = MutableLiveData<SearchParams>()
    private val requestPulse = MutableLiveData(0)
    private val rawDtos = MutableLiveData<List<ListingDto>>(emptyList())
    private val mappedListings = MutableLiveData<List<Listing>>(emptyList())

    init {
        searchInput.observeForever { params ->
            stagedParams.value = params.copy(cities = params.cities.toList())
        }

        stagedParams.observeForever {
            requestPulse.value = (requestPulse.value ?: 0) + 1
        }

        requestPulse.observeForever {
            val params = stagedParams.value ?: return@observeForever
            fetchListings(params)
        }

        rawDtos.observeForever { dtos ->
            mappedListings.value = dtos.mapNotNull { dto ->
                val city = City.fromApiValue(dto.city) ?: return@mapNotNull null
                val sofaType = SofaType.fromApiValue(dto.sofaType) ?: return@mapNotNull null
                Listing(
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

        mappedListings.observeForever { listings ->
            if (_state.value is UiState.Loading) {
                _state.value = UiState.Success(listings)
            }
        }
    }

    fun search(params: SearchParams) {
        _state.value = UiState.Loading
        searchInput.value = params
    }

    private fun fetchListings(params: SearchParams) {
        viewModelScope.launch {
            runCatching {
                api.getListings(
                    city = params.cities.map { it.name }.takeIf { it.isNotEmpty() },
                    minPriceCents = params.minPriceCents,
                    maxPriceCents = params.maxPriceCents,
                    hasFreeWifi = params.hasFreeWifi,
                    sofaType = params.sofaType?.name,
                )
            }.onSuccess { dtos ->
                rawDtos.value = dtos
            }.onFailure {
                val isConn = it is java.net.ConnectException || it is java.net.UnknownHostException
                _state.value = UiState.Error(it.message ?: "Unknown error", isConn)
            }
        }
    }

    class Factory(
        private val api: ListingsApi,
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return ResultsViewModel(api) as T
        }
    }
}
