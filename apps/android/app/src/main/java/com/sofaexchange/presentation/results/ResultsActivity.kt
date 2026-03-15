package com.sofaexchange.presentation.results

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.sofaexchange.data.remote.ApiClient
import com.sofaexchange.data.repository.ListingsRepositoryImpl
import com.sofaexchange.databinding.ActivityResultsBinding
import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.SofaType
import com.sofaexchange.domain.repository.SearchParams
import com.sofaexchange.domain.usecase.SearchListingsUseCase

class ResultsActivity : AppCompatActivity() {

    private lateinit var binding: ActivityResultsBinding
    private lateinit var viewModel: ResultsViewModel
    private lateinit var adapter: ListingAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityResultsBinding.inflate(layoutInflater)
        setContentView(binding.root)
        title = getString(R.string.results_title)

        // Manual DI: wire up the dependency chain without a DI framework
        val repository = ListingsRepositoryImpl(ApiClient.listingsApi)
        val useCase = SearchListingsUseCase(repository)
        val factory = ResultsViewModel.Factory(useCase)
        viewModel = ViewModelProvider(this, factory)[ResultsViewModel::class.java]

        setupRecyclerView()
        observeState()

        val params = extractSearchParams()
        viewModel.search(params)
    }

    private fun setupRecyclerView() {
        adapter = ListingAdapter()
        binding.listingsRecyclerView.layoutManager = LinearLayoutManager(this)
        binding.listingsRecyclerView.adapter = adapter
    }

    private fun observeState() {
        viewModel.state.observe(this) { state ->
            when (state) {
                is ResultsViewModel.UiState.Loading -> {
                    binding.progressBar.visibility = View.VISIBLE
                    binding.listingsRecyclerView.visibility = View.GONE
                    binding.statusTextView.visibility = View.GONE
                }
                is ResultsViewModel.UiState.Success -> {
                    binding.progressBar.visibility = View.GONE
                    if (state.listings.isEmpty()) {
                        binding.statusTextView.visibility = View.VISIBLE
                        binding.statusTextView.text = getString(com.sofaexchange.R.string.no_listings)
                        binding.listingsRecyclerView.visibility = View.GONE
                    } else {
                        binding.listingsRecyclerView.visibility = View.VISIBLE
                        binding.statusTextView.visibility = View.GONE
                        adapter.setItems(state.listings)
                    }
                }
                is ResultsViewModel.UiState.Error -> {
                    binding.progressBar.visibility = View.GONE
                    binding.listingsRecyclerView.visibility = View.GONE
                    binding.statusTextView.visibility = View.VISIBLE
                    binding.statusTextView.text = if (state.isConnectionError) {
                        getString(R.string.connection_error)
                    } else {
                        state.message
                    }
                }
            }
        }
    }

    private fun extractSearchParams(): SearchParams {
        val cityNames = intent.getStringArrayListExtra(EXTRA_CITY_NAMES) ?: emptyList<String>()
        val cities = cityNames.mapNotNull { City.fromApiValue(it) }

        val minPriceCents = intent.getIntExtra(EXTRA_MIN_PRICE_CENTS, -1).takeIf { it >= 0 }
        val maxPriceCents = intent.getIntExtra(EXTRA_MAX_PRICE_CENTS, -1).takeIf { it >= 0 }
        val hasFreeWifi = if (intent.hasExtra(EXTRA_HAS_FREE_WIFI)) intent.getBooleanExtra(EXTRA_HAS_FREE_WIFI, false) else null
        val sofaTypeName = intent.getStringExtra(EXTRA_SOFA_TYPE_NAME)
        val sofaType = sofaTypeName?.let { SofaType.fromApiValue(it) }

        return SearchParams(
            cities        = cities,
            minPriceCents = minPriceCents,
            maxPriceCents = maxPriceCents,
            hasFreeWifi   = hasFreeWifi,
            sofaType      = sofaType,
        )
    }

    companion object {
        private const val EXTRA_CITY_NAMES     = "extra_city_names"
        private const val EXTRA_MIN_PRICE_CENTS = "extra_min_price_cents"
        private const val EXTRA_MAX_PRICE_CENTS = "extra_max_price_cents"
        private const val EXTRA_HAS_FREE_WIFI  = "extra_has_free_wifi"
        private const val EXTRA_SOFA_TYPE_NAME = "extra_sofa_type_name"

        fun newIntent(
            context: Context,
            cityNames: List<String>,
            minPriceCents: Int?,
            maxPriceCents: Int?,
            hasFreeWifi: Boolean?,
            sofaTypeName: String?,
        ): Intent = Intent(context, ResultsActivity::class.java).apply {
            putStringArrayListExtra(EXTRA_CITY_NAMES, ArrayList(cityNames))
            minPriceCents?.let { putExtra(EXTRA_MIN_PRICE_CENTS, it) }
            maxPriceCents?.let { putExtra(EXTRA_MAX_PRICE_CENTS, it) }
            hasFreeWifi?.let { putExtra(EXTRA_HAS_FREE_WIFI, it) }
            sofaTypeName?.let { putExtra(EXTRA_SOFA_TYPE_NAME, it) }
        }
    }
}
