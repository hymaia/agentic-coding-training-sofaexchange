SELECT
    sofa_type,
    COUNT(*)                     AS sofa_count,
    AVG(price_per_night_eur)     AS avg_price_eur
FROM {{ ref('int_sofas_with_city') }}
GROUP BY sofa_type
ORDER BY sofa_count DESC
