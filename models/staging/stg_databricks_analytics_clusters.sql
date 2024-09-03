with
    source as (
        select *
        from {{ source('raw_api_tables_databricks', 'clusters') }}
    )

    , renamed as (
        select
            cast(cluster_id as string) as cluster_id
            , case 
                when cluster_source like '%JOB%' then regexp_extract(cluster_name, '[^-]+$', 0)
                else cluster_name
            end as cluster_name
            , cast(cluster_source as string) as cluster_source
            , cast(creator_user_name as string) as creator_user_name
            , cast(autotermination_minutes as int) as autotermination_minutes
            , cast(driver_node_type_id as string) as driver_node_type_id
            , cast(enable_elastic_disk as boolean) as enable_elastic_disk
            , cast(enable_local_disk_encryption as boolean) as enable_local_disk_encryption
            , cast(init_scripts_safe_mode as boolean) as init_scripts_safe_mode
            , instance_source.node_type_id as instance_node_type_id
            , cast(last_state_loss_time as bigint) as last_state_loss_time
            , cast(node_type_id as string) as node_type_id
            , cast(num_workers as int) as num_workers
            , cast(spark_context_id as bigint) as spark_context_id
            , cast(spark_version as string) as spark_version
            , cast(start_time as bigint) as start_time
            , cast(state as string) as cluster_state
            , cast(state_message as string) as state_message
            , cast(terminated_time as bigint) as terminated_time
            , termination_reason.code as termination_reason_code
            , termination_reason.type as termination_reason_type
            , cast(inserteddate as date) as inserted_date      
        from source
        qualify
            row_number() over(
                partition by cluster_id
                order by inserteddate desc
            ) = 1
    )

select * 
from renamed
