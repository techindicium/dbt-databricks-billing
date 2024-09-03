with 
    billing_data as (
        select *
        from {{ ref('stg_databricks_analytics_billing') }}
    )

    , price_data as (
        select *
        from {{ ref('stg_databricks_analytics_pricing') }}
    )

    , warehouses as (
        select *
        from {{ ref('dim_databricks_analytics_warehouses') }}
    )

    , clusters as (
        select *
        from {{ ref('dim_databricks_analytics_clusters') }}
    )

    , get_pricing_info as (
        select
            billing_data.account_id
            , billing_data.workspace_id
            , billing_data.record_id
            , billing_data.sku
            , billing_data.cloud
            , billing_data.start_datetime
            , billing_data.end_datetime
            , billing_data.usage_date
            , billing_data.machine_hours
            , billing_data.custom_tags
            , billing_data.dbu_unit
            , billing_data.dbus
            , billing_data.cluster_id
            , billing_data.job_id
            , billing_data.warehouse_id
            , billing_data.instance_pool_id
            , billing_data.node_type
            , billing_data.job_run_id
            , billing_data.notebook_id
            , billing_data.dlt_pipeline_id
            , billing_data.endpoint_name
            , billing_data.endpoint_id
            , billing_data.dlt_update_id
            , billing_data.dlt_maintenance_id
            , billing_data.identity_involved_usage
            , billing_data.record_type
            , billing_data.ingestion_date
            , billing_data.billing_origin_product
            , billing_data.jobs_tier
            , billing_data.sql_tier
            , billing_data.dlt_tier
            , billing_data.is_serverless
            , billing_data.is_photon
            , billing_data.serving_type
            , billing_data.usage_type
            , price_data.dbus_default_unit_price as default_price
            , price_data.dbus_promotional_unit_price as promotional_price
            , price_data.dbus_effective_unit_price as effective_price
            , (billing_data.dbus * price_data.dbus_effective_unit_price) as total_cost
            , case
                when (
                    current_date() = last_day(current_date())
                    and month(current_date()) = month(last_day(current_date()))
                 ) then (billing_data.dbus * price_data.dbus_effective_unit_price)
                else (
                    (billing_data.dbus * price_data.dbus_effective_unit_price) /
                    day(current_date())
                ) * day(last_day(current_date()))
            end as simple_projection_cost
        from billing_data
        left join price_data
            on billing_data.cloud = price_data.cloud
            and billing_data.sku = price_data.sku
            and billing_data.end_datetime >= price_data.price_start_time
            and (
                billing_data.end_datetime <= price_data.price_end_time
                or price_end_time is null
            )
    )

    , create_surrogate_key as (
        select 
            {{ dbt_utils.generate_surrogate_key(['get_pricing_info.record_id']) }} as databricks_monitoring_sk
            , warehouses.warehouse_sk as warehouse_fk
            , clusters.cluster_sk as cluster_fk
            , get_pricing_info.account_id
            , get_pricing_info.workspace_id
            , get_pricing_info.record_id
            , get_pricing_info.sku
            , get_pricing_info.cloud
            , get_pricing_info.start_datetime
            , get_pricing_info.end_datetime
            , get_pricing_info.usage_date
            , get_pricing_info.machine_hours
            , get_pricing_info.custom_tags
            , get_pricing_info.dbu_unit
            , get_pricing_info.dbus
            , get_pricing_info.cluster_id
            , coalesce(
                clusters.cluster_name
                , warehouses.warehouse_name
                , get_pricing_info.cluster_id
                , get_pricing_info.warehouse_id
            ) as cluster_name
            , get_pricing_info.job_id
            , get_pricing_info.warehouse_id
            , get_pricing_info.instance_pool_id
            , get_pricing_info.node_type
            , get_pricing_info.job_run_id
            , get_pricing_info.notebook_id
            , get_pricing_info.dlt_pipeline_id
            , get_pricing_info.endpoint_name
            , get_pricing_info.endpoint_id
            , get_pricing_info.dlt_update_id
            , get_pricing_info.dlt_maintenance_id
            , get_pricing_info.identity_involved_usage
            , get_pricing_info.record_type
            , get_pricing_info.ingestion_date
            , get_pricing_info.billing_origin_product
            , get_pricing_info.jobs_tier
            , get_pricing_info.sql_tier
            , get_pricing_info.dlt_tier
            , get_pricing_info.is_serverless
            , get_pricing_info.is_photon
            , get_pricing_info.serving_type
            , get_pricing_info.usage_type
            , get_pricing_info.default_price
            , get_pricing_info.promotional_price
            , get_pricing_info.effective_price
            , get_pricing_info.total_cost
            , get_pricing_info.simple_projection_cost
        from get_pricing_info
        left join warehouses
            on get_pricing_info.warehouse_id = warehouses.warehouse_id
        left join clusters
            on get_pricing_info.cluster_id = clusters.cluster_id
    )

select *
from create_surrogate_key
