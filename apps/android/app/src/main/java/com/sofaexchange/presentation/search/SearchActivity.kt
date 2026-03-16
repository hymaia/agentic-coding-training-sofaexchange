package com.sofaexchange.presentation.search

import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import com.sofaexchange.R
import com.sofaexchange.databinding.ActivitySearchBinding
import com.sofaexchange.domain.model.City
import com.sofaexchange.domain.model.SofaType
import com.sofaexchange.presentation.results.ResultsActivity

class SearchActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySearchBinding
    private lateinit var viewModel: SearchViewModel
    private var selectedCity: City? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySearchBinding.inflate(layoutInflater)
        setContentView(binding.root)

        viewModel = ViewModelProvider(this)[SearchViewModel::class.java]

        setupCityDropdown()
        setupSofaTypeSpinner()
        setupSearchButton()
    }

    private fun setupCityDropdown() {
        val cityOptions = listOf(getString(R.string.sofa_type_any)) + City.values().map { city ->
            getString(resources.getIdentifier("city_${city.name}", "string", packageName))
        }
        val adapter = ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line, cityOptions)
        binding.cityDropdown.setAdapter(adapter)
        binding.cityDropdown.setText(cityOptions.first(), false)
        binding.cityDropdown.setOnItemClickListener { _, _, position, _ ->
            selectedCity = if (position == 0) null else City.values()[position - 1]
        }
    }

    private fun setupSofaTypeSpinner() {
        val sofaTypeOptions = listOf(getString(R.string.sofa_type_any)) + SofaType.values().map { sofa ->
            getString(resources.getIdentifier("sofa_type_${sofa.name.lowercase()}", "string", packageName))
        }
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, sofaTypeOptions)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.sofaTypeSpinner.adapter = adapter
    }

    private fun setupSearchButton() {
        binding.searchButton.setOnClickListener {
            val selectedCities = selectedCity?.let { listOf(it) } ?: emptyList()

            // Sofa type: index 0 = "Any", indices 1+ map to SofaType values
            val sofaTypeIndex = binding.sofaTypeSpinner.selectedItemPosition
            val selectedSofaType = if (sofaTypeIndex == 0) null else SofaType.values()[sofaTypeIndex - 1]

            val hasFreeWifi = if (binding.wifiSwitch.isChecked) true else null

            val intent = ResultsActivity.newIntent(
                context      = this,
                cityNames    = selectedCities.map { it.name },
                hasFreeWifi  = hasFreeWifi,
                sofaTypeName = selectedSofaType?.name,
            )
            startActivity(intent)
        }
    }
}
