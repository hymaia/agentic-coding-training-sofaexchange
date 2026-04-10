SELECT
    id,
    title,
    city_key,
    country_code,
    price_per_night_eur,
    sofa_type,
    has_free_wifi,
    price_category,
    is_convertible,
    created_at,
    updated_at
FROM {{ ref('int_sofas_enriched') }}
