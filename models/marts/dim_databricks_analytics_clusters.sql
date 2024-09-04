with 
    clusters as (
        select *
        from {{ ref('stg_databricks_analytics_clusters') }}
    )

    , create_surrogate_key as (
        select
            {{ dbt_utils.generate_surrogate_key(['cluster_id']) }} as cluster_sk
            , cluster_id
            , cluster_name
            , cluster_source
            , creator_user_name
            , autotermination_minutes
            , driver_node_type_id
            , enable_elastic_disk
            , enable_local_disk_encryption
            , init_scripts_safe_mode
            , instance_node_type_id
            , last_state_loss_time
            , node_type_id
            , num_workers
            , spark_context_id
            , spark_version
            , start_time
            , cluster_state
            , state_message
            , terminated_time
            , termination_reason_code
            , termination_reason_type
            , inserted_date
        from clusters
    )

select *
from create_surrogate_key
    