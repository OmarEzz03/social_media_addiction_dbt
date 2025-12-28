WITH source AS (
    SELECT * 
    FROM {{ ref('silver_students') }}
), 
transformed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['most_used_platform']) }} AS platform_id,
        most_used_platform
    FROM source
    GROUP BY most_used_platform
)

SELECT *
FROM transformed