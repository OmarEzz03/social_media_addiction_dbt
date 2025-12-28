WITH source AS (
    SELECT * 
    FROM {{ source('bronze', 'STUDENTS SOCIAL MEDIA ADDICTION') }}
), 
renamed AS (
    SELECT
        student_id::int                                 AS student_id,
        TRY_CAST(age AS INT)                            AS age,
        LOWER(TRIM(gender))                             AS gender,
        LOWER(TRIM(academic_level))                     AS academic_level,
        LOWER(TRIM(country))                            AS country,
        LOWER(TRIM(relationship_status))                AS relationship_status,
        TRY_CAST(avg_daily_usage_hours AS FLOAT)        AS avg_daily_usage_hours,
        LOWER(TRIM(most_used_platform))                 AS most_used_platform,
        affects_academic_performance::boolean           AS affects_academic_performance,
        TRY_CAST(sleep_hours_per_night AS FLOAT)        AS sleep_hours_per_night,
        TRY_CAST(mental_health_score AS INT)            AS mental_health_score,
        TRY_CAST(conflicts_over_social_media AS INT)    AS conflicts_over_social_media,
        TRY_CAST(addicted_score AS INT)                 AS addicted_score
    FROM source
)

SELECT *
FROM renamed