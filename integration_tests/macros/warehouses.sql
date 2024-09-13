{% macro warehouses() %}
{% set create_table %}
create or replace table {{ target.database }}.{{ target.schema }}.warehouses (
    auto_resume BOOLEAN,
    auto_stop_mins BIGINT,
    channel STRUCT<name STRING>,
    cluster_size STRING,
    creator_id BIGINT,
    creator_name STRING,
    enable_photon BOOLEAN,
    enable_serverless_compute BOOLEAN,
    id STRING,
    jdbc_url STRING,
    max_num_clusters BIGINT,
    min_num_clusters BIGINT,
    name STRING,
    num_active_sessions BIGINT,
    num_clusters BIGINT,
    odbc_params STRUCT<
        hostname STRING, 
        path STRING, 
        port BIGINT, 
        protocol STRING
    >,
    size STRING,
    spot_instance_policy STRING,
    state STRING,
    warehouse_type STRING,
    InsertedDate TIMESTAMP
);
{% endset %}

{% set insert_table %}
INSERT INTO {{ target.database }}.{{ target.schema }}.warehouses VALUES
(
    CAST(true AS BOOLEAN),
    CAST(10 AS BIGINT),
    STRUCT('name' AS STRING),
    CAST('Small' AS STRING),
    CAST(3605356301923516 AS BIGINT),
    CAST('analm.tech' AS STRING),
    CAST(true AS BOOLEAN),
    CAST(true AS BOOLEAN),
    CAST('b01cf0e0cd0feafe' AS STRING),
    CAST('jdbc:spark://adb-abricks.net:443/default' AS STRING),
    CAST(1 AS BIGINT),
    CAST(1 AS BIGINT),
    CAST('Serverless Starter Warehouse' AS STRING),
    CAST(0 AS BIGINT),
    CAST(1 AS BIGINT),
    STRUCT(
        'adb-1240icks.net' AS hostname,
        '/sql/1cf0d0feafe' AS path,
        443 AS port,
        'https' AS protocol
    ),
    CAST('SMALL' AS STRING),
    CAST('COST_OPTIMIZED' AS STRING),
    CAST('RUNNING' AS STRING),
    CAST('PRO' AS STRING),
    CAST('2024-08-01T18:08:28.234Z' AS TIMESTAMP)
);
{% endset %}

{% do run_query(create_table) %}
{% do log("finished creating table warehouses", info=true) %}

{% do run_query(insert_table) %}
{% do log("finished insert table warehouses", info=true) %}
{% endmacro %}
