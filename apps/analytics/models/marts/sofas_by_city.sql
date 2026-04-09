SELECT
    city_key,
    city_en,
    city_fr,
    city_it,
    country_code,
    COUNT(*)                     AS sofa_count,
    AVG(price_per_night_eur)     AS avg_price_eur
FROM {{ ref('int_sofas_with_city') }}
GROUP BY city_key, city_en, city_fr, city_it, country_code
ORDER BY sofa_count DESC
