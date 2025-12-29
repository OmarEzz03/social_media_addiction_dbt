WITH source AS (
    SELECT * 
    FROM {{ ref('silver_students') }}
),
transformed AS (
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key([
            "extracted_at"
        ]) }} AS date_id,
        extracted_at as full_date,
        extract(year from extracted_at)  as year,
        extract(month from extracted_at) as month,
        extract(day from extracted_at)   as day
    FROM source
)

SELECT *
FROM transformed