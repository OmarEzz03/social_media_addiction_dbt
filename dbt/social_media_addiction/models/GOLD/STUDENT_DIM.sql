WITH source AS (
    SELECT * 
    FROM {{ ref('silver_students') }}
), 
transformed AS (
    SELECT
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