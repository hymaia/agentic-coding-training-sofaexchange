SELECT
    id,
    title,
    city_key,
    city_en,
    city_fr,
    city_it,
    country_code,
    price_per_night_eur,
    sofa_type,
    has_free_wifi,
    created_at,
    updated_at
FROM {{ ref('int_sofas_with_city') }}
