package com.sofaexchange.presentation.results

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.sofaexchange.domain.model.Listing
import com.sofaexchange.domain.repository.SearchParams
import com.sofaexchange.domain.usecase.SearchListingsUseCase
import kotlinx.coroutines.launch

class ResultsViewModel(
    private val useCase: SearchListingsUseCase,
) : ViewModel() {

    sealed class UiState {
        object Loading : UiState()
        data class Success(val listings: List<Listing>) : UiState()
        data class Error(val message: String, val isConnectionError: Boolean = false) : UiState()
    }

    private val _state = MutableLiveData<UiState>()
    val state: LiveData<UiState> = _state

    fun search(params: SearchParams) {
        _state.value = UiState.Loading
        viewModelScope.launch {
            runCatching { useCase.execute(params) }
                .onSuccess { _state.value = UiState.Success(it) }
                .onFailure {
                    val isConn = it is java.net.ConnectException || it is java.net.UnknownHostException
                    _state.value = UiState.Error(it.message ?: "Unknown error", isConn)
                }
        }
    }

    class Factory(
        private val useCase: SearchListingsUseCase,
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            return ResultsViewModel(useCase) as T
        }
    }
}
