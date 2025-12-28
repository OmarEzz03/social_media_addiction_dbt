WITH source AS (
    SELECT * 
    FROM {{ ref('stg_students_survey') }}
), 
filtered AS (
    SELECT
        student_id,
        age,
        {{ gender_trans('gender') }} AS gender,
        academic_level,
        country,
        relationship_status,
        avg_daily_usage_hours,
        most_used_platform,
        affects_academic_performance,
        sleep_hours_per_night,
        mental_health_score,
        conflicts_over_social_media,
        addicted_score,
        extracted_at
    FROM source
    WHERE age IS NOT NULL 
    AND student_id IS NOT NULL 
    AND addicted_score IS NOT NULL 
    AND most_used_platform IS NOT NULL 
    AND avg_daily_usage_hours IS NOT NULL 
    AND sleep_hours_per_night IS NOT NULL 
    AND mental_health_score IS NOT NULL 
    AND conflicts_over_social_media IS NOT NULL
    AND extracted_at IS NOT NULL
    AND age BETWEEN 16 AND 25
    AND mental_health_score BETWEEN 1 AND 10
    AND addicted_score BETWEEN 1 AND 10
    AND avg_daily_usage_hours <= 24

)

SELECT *
FROM filtered