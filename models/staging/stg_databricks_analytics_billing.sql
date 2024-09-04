with
    source as (
        select * 
        from {{ source('raw_system_tables_databricks', 'usage') }}
    )

    , renamed as (
        select 
            cast(account_id as string) as account_id
            , cast(workspace_id as string) as workspace_id
            , cast(record_id as string) as record_id
            , cast(sku_name as string) as sku
            , cast(cloud as string) as cloud
            , cast(usage_start_time as timestamp) as start_datetime
            , cast(usage_end_time as timestamp) as end_datetime
            , cast(usage_date as date) as usage_date
            , datediff(HOUR, usage_end_time, usage_start_time) as machine_hours
            , custom_tags
            , cast(usage_unit as string) as dbu_unit
            , round(usage_quantity, 2) as dbus
            , usage_metadata.cluster_id as cluster_id
            , usage_metadata.job_id as job_id
            , usage_metadata.warehouse_id as warehouse_id
            , usage_metadata.instance_pool_id as instance_pool_id
            , usage_metadata.node_type as node_type
            , usage_metadata.job_run_id as job_run_id
            , usage_metadata.notebook_id as notebook_id
            , usage_metadata.dlt_pipeline_id as dlt_pipeline_id
            , usage_metadata.endpoint_name as endpoint_name
            , usage_metadata.endpoint_id as endpoint_id
            , usage_metadata.dlt_update_id as dlt_update_id
            , usage_metadata.dlt_maintenance_id as dlt_maintenance_id
            , identity_metadata.run_as as identity_involved_usage
            , cast(record_type as string) as record_type
            , cast(ingestion_date as date) as ingestion_date
            , cast(billing_origin_product as string) as billing_origin_product
            , product_features.jobs_tier as jobs_tier
            , product_features.sql_tier as sql_tier
            , product_features.dlt_tier as dlt_tier
            , case 
                when sku_name like '%SERVERLESS%' then true
                else product_features.is_serverless
            end as is_serverless
            , product_features.is_photon as is_photon
            , product_features.serving_type as serving_type
            , cast(usage_type as string) as usage_type        
        from source
    )

select * 
from renamed
