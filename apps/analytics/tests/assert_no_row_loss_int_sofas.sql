SELECT 1
WHERE (SELECT COUNT(*) FROM {{ ref('int_sofas_enriched') }})
   != (SELECT COUNT(*) FROM {{ ref('stg_sofas') }})
