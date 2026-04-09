SELECT 1
FROM {{ ref('int_sofas_enriched') }}
WHERE sofa_type = 'SOFA_BED'
  AND price_category = 'PREMIUM'
  AND price_per_night_eur < 80
