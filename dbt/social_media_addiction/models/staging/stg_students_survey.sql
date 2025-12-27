WITH source AS (
    SELECT * 
    FROM {{ source('bronze', 'STUDENTS SOCIAL MEDIA ADDICTION') }}
), 
renamed AS (
    SELECT
        student_id::int                                 AS student_id,
        TRY_CAST(age AS INT)                            AS age,
        {{lower_trim(gender)}}                             AS gender,
        {{lower_trim(academic_level)}}                      AS academic_level,
        {{lower_trim(country)}}                             AS country,
        {{lower_trim(relationship_status)}}                 AS relationship_status,
        TRY_CAST(avg_daily_usage_hours AS FLOAT)        AS avg_daily_usage_hours,
        {{lower_trim(most_used_platform)}}                  AS most_used_platform,
        affects_academic_performance::boolean           AS affects_academic_performance,
        TRY_CAST(sleep_hours_per_night AS FLOAT)        AS sleep_hours_per_night,
        TRY_CAST(mental_health_score AS INT)            AS mental_health_score,
        TRY_CAST(conflicts_over_social_media AS INT)    AS conflicts_over_social_media,
        TRY_CAST(addicted_score AS INT)                 AS addicted_score
    FROM source
)

SELECT *
FROM renamed