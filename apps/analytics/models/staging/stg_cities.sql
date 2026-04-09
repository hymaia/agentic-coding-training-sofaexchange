SELECT
    city_key,
    country_code,
    city_en,
    city_fr,
    city_it
FROM {{ ref('cities') }}
