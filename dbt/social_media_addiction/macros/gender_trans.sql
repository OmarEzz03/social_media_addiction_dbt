{% macro gender_trans(col) %}
    case
        when {{ col }} in ('male', 'M', 'm', 'mAle') then 'Male'
        when {{ col }} in ('female', 'F', 'f', 'fEmale') then 'Female'
        else 'Other'
    end
{% endmacro %}