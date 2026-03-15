package com.sofaexchange.presentation.results

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.sofaexchange.databinding.ItemListingBinding
import com.sofaexchange.domain.model.Listing

class ListingAdapter(
    private val items: MutableList<Listing> = mutableListOf(),
) : RecyclerView.Adapter<ListingAdapter.ViewHolder>() {

    inner class ViewHolder(private val binding: ItemListingBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(item: Listing) {
            binding.titleTextView.text    = item.title
            val cityResId = itemView.context.resources.getIdentifier("city_${item.city.name}", "string", itemView.context.packageName)
            binding.cityTextView.text = if (cityResId != 0) itemView.context.getString(cityResId) else item.city.displayName
            binding.priceTextView.text    = "€${"%.2f".format(item.pricePerNightCents / 100.0)} ${itemView.context.getString(com.sofaexchange.R.string.per_night)}"
            val sofaResId = itemView.context.resources.getIdentifier("sofa_type_${item.sofaType.name.lowercase()}", "string", itemView.context.packageName)
            binding.sofaTypeTextView.text = if (sofaResId != 0) itemView.context.getString(sofaResId) else item.sofaType.displayName
            binding.wifiTextView.text     = if (item.hasFreeWifi) itemView.context.getString(com.sofaexchange.R.string.wifi_included) else itemView.context.getString(com.sofaexchange.R.string.no_wifi)
        }
    }

    fun setItems(newItems: List<Listing>) {
        items.clear()
        items.addAll(newItems)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder =
        ViewHolder(ItemListingBinding.inflate(LayoutInflater.from(parent.context), parent, false))

    override fun onBindViewHolder(holder: ViewHolder, position: Int) = holder.bind(items[position])

    override fun getItemCount(): Int = items.size
}
