WITH sofa_beds AS (
    SELECT
        s.id,
        s.title,
        s.city AS city_key,
        c.city_en,
        c.city_fr,
        c.city_it,
        c.country_code,
        s.price_per_night_eur,
        s.sofa_type,
        s.has_free_wifi,
        s.created_at,
        s.updated_at,
        CASE
            WHEN s.price_per_night_eur >= 80 THEN 'PREMIUM'
            WHEN s.price_per_night_eur >= 40 THEN 'STANDARD'
            ELSE 'BUDGET'
        END AS price_category,
        TRUE AS is_convertible
    FROM {{ ref('stg_sofas') }} AS s
    LEFT JOIN {{ ref('stg_cities') }} AS c ON s.city = c.city_key
    WHERE s.sofa_type = 'SOFA_BED'
),

simple_sofas AS (
    SELECT
        s.id,
        s.title,
        s.city AS city_key,
        c.city_en,
        c.city_fr,
        c.city_it,
        c.country_code,
        s.price_per_night_eur,
        s.sofa_type,
        s.has_free_wifi,
        s.created_at,
        s.updated_at,
        CASE
            WHEN s.price_per_night_eur >= 60 THEN 'PREMIUM'
            WHEN s.price_per_night_eur >= 30 THEN 'STANDARD'
            ELSE 'BUDGET'
        END AS price_category,
        FALSE AS is_convertible
    FROM {{ ref('stg_sofas') }} AS s
    LEFT JOIN {{ ref('stg_cities') }} AS c ON s.city = c.city_key
    WHERE s.sofa_type = 'SIMPLE_SOFA'
)

SELECT * FROM sofa_beds
UNION ALL
SELECT * FROM simple_sofas
