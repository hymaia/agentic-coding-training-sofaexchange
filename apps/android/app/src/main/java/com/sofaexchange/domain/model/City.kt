package com.sofaexchange.domain.model

enum class City(val displayName: String) {
    LONDON("London"),
    PARIS("Paris"),
    MILAN("Milan"),
    MADRID("Madrid"),
    LISBON("Lisbon"),
    BERLIN("Berlin"),
    DUBLIN("Dublin"),
    EDINBURGH("Edinburgh"),
    VIENNA("Vienna");

    companion object {
        fun fromApiValue(value: String): City? = values().find { it.name == value }
    }
}
