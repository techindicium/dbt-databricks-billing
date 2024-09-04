with 
    warehouses as (
        select *
        from {{ ref('stg_databricks_analytics_warehouses') }}
    )

    , create_surrogate_key as (
        select
            {{ dbt_utils.generate_surrogate_key(['warehouse_id']) }} as warehouse_sk
            , warehouse_id
            , auto_resume
            , auto_stop_mins
            , channel_name
            , cluster_size
            , creator_id
            , creator_user
            , creator_email
            , enable_photon
            , enable_serverless_compute
            , jdbc_url
            , max_num_clusters
            , min_num_clusters
            , warehouse_name
            , case 
                when warehouse_name like '%Serverless%' then true
                else false
            end as is_serverless
            , num_active_sessions
            , num_clusters
            , warehouse_size
            , spot_instance_policy
            , warehouse_state
            , warehouse_type
            , inserted_date
        from warehouses
    )

select *
from create_surrogate_key
    