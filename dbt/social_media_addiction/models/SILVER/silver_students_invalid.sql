WITH source AS (
    SELECT * 
    FROM {{ ref('stg_students_survey') }}
), 
filtered AS (
    SELECT
        student_id,
        age,
        {{gender_trans('gender')}}                             AS gender,
        academic_level,
        country,
        relationship_status,
        avg_daily_usage_hours,
        most_used_platform,
        affects_academic_performance,
        sleep_hours_per_night,
        mental_health_score,
        conflicts_over_social_media,
        addicted_score
    FROM source
    WHERE age IS NULL 
    OR student_id IS NULL 
    OR addicted_score IS NULL 
    OR most_used_platform IS NULL 
    OR avg_daily_usage_hours IS NULL 
    OR sleep_hours_per_night IS NULL 
    OR mental_health_score IS NULL 
    OR conflicts_over_social_media IS NULL
    OR age NOT BETWEEN 16 AND 25
    OR mental_health_score NOT BETWEEN 1 AND 10
    OR addicted_score NOT BETWEEN 1 AND 10
    OR avg_daily_usage_hours > 24

)

SELECT *
FROM filtered