package com.sofaexchange.domain.model

enum class SofaType(val displayName: String) {
    SOFA_BED("Sofa Bed"),
    SIMPLE_SOFA("Simple Sofa");

    companion object {
        fun fromApiValue(value: String): SofaType? = values().find { it.name == value }
    }
}
