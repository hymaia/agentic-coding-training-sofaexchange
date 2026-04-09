SELECT
    id,
    title,
    city,
    price_per_night_eur,
    sofa_type,
    has_free_wifi,
    created_at,
    updated_at
FROM {{ ref('sofas') }}
