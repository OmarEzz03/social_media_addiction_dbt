select 
    {{dbt_utils.generate_surrogate_key([
        "student.student_key",
        "date_dim.date_id"
    ])}} AS fact_student_survey_key,
    student.student_key,
    date_dim.date_id,
    platform.platform_id,

    src.avg_daily_usage_hours,
    src.sleep_hours_per_night,
    src.mental_health_score,
    src.conflicts_over_social_media,
    src.addicted_score,
    src.affects_academic_performance
FROM {{ ref('silver_students') }} src
JOIN {{ ref('PLATFORM_DIM') }} platform
  ON src.most_used_platform = platform.most_used_platform
JOIN {{ ref('DATE_DIM') }} date_dim
  ON src.extracted_at = date_dim.full_date
JOIN {{ ref('STUDENT_DIM') }} student
  ON src.student_id = student.student_id