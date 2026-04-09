SELECT
    sofas.id,
    sofas.title,
    sofas.city AS city_key,
    cities.city_en,
    cities.city_fr,
    cities.city_it,
    cities.country_code,
    sofas.price_per_night_eur,
    sofas.sofa_type,
    sofas.has_free_wifi,
    sofas.created_at,
    sofas.updated_at
FROM
    {{ ref('stg_sofas') }} AS sofas
    LEFT JOIN {{ ref('stg_cities') }} AS cities
    ON sofas.city = cities.city_key
