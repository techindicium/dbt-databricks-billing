{% macro clusters() %}
{% set create_table %}
create or replace table {{ target.database }}.{{ target.schema }}.clusters (
    autotermination_minutes BIGINT,
    cluster_id STRING,
    cluster_name STRING,
    cluster_source STRING,
    creator_user_name STRING,
    default_tags STRUCT<
        ClusterId STRING, 
        ClusterName STRING, 
        Creator STRING, 
        Vendor STRING
    >,
    driver_instance_source STRUCT<
        node_type_id STRING
    >,
    driver_node_type_id STRING,
    enable_elastic_disk BOOLEAN,
    enable_local_disk_encryption BOOLEAN,
    init_scripts_safe_mode BOOLEAN,
    instance_source STRUCT<
        node_type_id STRING
    >,
    last_state_loss_time BIGINT,
    node_type_id STRING,
    num_workers BIGINT,
    spark_context_id BIGINT,
    spark_version STRING,
    start_time BIGINT,
    state STRING,
    state_message STRING,
    terminated_time BIGINT,
    termination_reason STRUCT<
        code STRING, 
        parameters STRUCT<
            inactivity_duration_min STRING
        >, 
        type STRING
    >,
    InsertedDate TIMESTAMP
);
{% endset %}

{% set insert_table %}
INSERT INTO {{ target.database }}.{{ target.schema }}.clusters VALUES
(
    CAST(10 AS BIGINT),
    CAST('cluster_01' AS STRING),
    CAST('Cluster A' AS STRING),
    CAST('manual' AS STRING),
    CAST('user_a' AS STRING),
    STRUCT(
        'c-12345' AS ClusterId,
        'Cluster A' AS ClusterName,
        'user_a' AS Creator,
        'aws' AS Vendor
    ),
    STRUCT(
        'm5.xlarge' AS node_type_id
    ),
    CAST('m5.xlarge' AS STRING),
    CAST(true AS BOOLEAN),
    CAST(true AS BOOLEAN),
    CAST(false AS BOOLEAN),
    STRUCT(
        'r5.large' AS node_type_id
    ),
    CAST(1692484800000 AS BIGINT),
    CAST('r5.xlarge' AS STRING),
    CAST(4 AS BIGINT),
    CAST(1012345678 AS BIGINT),
    CAST('3.1.2' AS STRING),
    CAST(1692484500000 AS BIGINT),
    CAST('RUNNING' AS STRING),
    CAST('No issues' AS STRING),
    CAST(1692484700000 AS BIGINT),
    STRUCT(
        'INACTIVITY' AS code,
        STRUCT(
            '30' AS inactivity_duration_min
        ) AS parameters,
        'EXPIRED' AS type
    ),
    CAST('2024-08-01T18:08:28.234Z' AS TIMESTAMP)
);
{% endset %}

{% do run_query(create_table) %}
{% do log("finished creating table clusters", info=true) %}

{% do run_query(insert_table) %}
{% do log("finished insert table clusters", info=true) %}
{% endmacro %}
