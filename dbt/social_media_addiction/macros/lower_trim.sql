{%- macro lower_trim(col) -%}
    LOWER(TRIM({{ col }}))
{%- endmacro -%}