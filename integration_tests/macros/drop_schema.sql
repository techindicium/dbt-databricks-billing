{% macro drop_schemas_dev(pattern) %}

    {#- This macro will drop all schemas following the pattern -#}

    {% set get_dev_schemas_query %}
        show schemas like '{{ pattern }}';
    {% endset %}

    {% if execute %}
        {% set dev_schemas = run_query(get_dev_schemas_query).columns[0].values() %}
    {% endif %}

    {% for schema_name in dev_schemas %}

        {% if schema_name in ['raw', 'trusted', 'refined', 'delivery', 'snapshots', 'monitoring'] %}
        
            {% do log("Can't drop " + schema_name + " schema", info=True) %}

        {% else %}

            {{ drop_schema(schema_name) }}

            {% do log("Dropped schema " ~ schema_name, info = true) %}

        {% endif %}

    {% endfor %}

{% endmacro %}