{% macro minutes_to_hours(column_name, precision=2) %}
  ROUND({{column_name}} / 60, precision)
{% endmacro %}