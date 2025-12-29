WITH source AS (
    SELECT * 
    FROM {{ ref('silver_students') }}
), 
transformed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['student_id']) }} AS student_key,
        student_id,
        age,
        gender,
        academic_level,
        country,
        relationship_status
    FROM source
)

SELECT *
FROM transformed