with
    source as (
        select *
        from {{ source('raw_api_tables_databricks', 'warehouses') }}
    )

    , renamed as (
        select
            cast(auto_resume as boolean) as auto_resume
            , cast(auto_stop_mins as int) as auto_stop_mins
            , channel.name as channel_name
            , cast(cluster_size as string) as cluster_size
            , cast(creator_id as bigint) as creator_id
            , split_part(creator_name, '@', 1) as creator_user
            , cast(creator_name as string) as creator_email
            , cast(enable_photon as boolean) as enable_photon
            , cast(enable_serverless_compute as boolean) as enable_serverless_compute
            , cast(id as string) as warehouse_id
            , cast(jdbc_url as string) as jdbc_url
            , cast(max_num_clusters as int) as max_num_clusters
            , cast(min_num_clusters as int) as min_num_clusters
            , cast(name as string) as warehouse_name
            , cast(num_active_sessions as int) as num_active_sessions
            , cast(num_clusters as int) as num_clusters
            , cast(size as string) as warehouse_size
            , cast(spot_instance_policy as string) as spot_instance_policy
            , cast(state as string) as warehouse_state
            , cast(warehouse_type as string) as warehouse_type
            , cast(inserteddate as date) as inserted_date     
        from source
        qualify
            row_number() over(
                partition by warehouse_id
                order by inserteddate desc
            ) = 1
    )   

select *
from renamed
