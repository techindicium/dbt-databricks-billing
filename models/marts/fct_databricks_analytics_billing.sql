with
    dim_dates as (
        select date_day
        from {{ ref('dim_dates') }}
    )

    , dim_cluster as (
        select
            cluster_sk 
            , cluster_id
            , cluster_name
            , owner_id
            , node_type
            , custom_tags
        from {{ ref('dim_databricks_analytics_cluster') }}
    )

    , dim_sku as (
        select 
            sku_sk
            , sku
        from {{ ref('dim_databricks_analytics_sku') }}
    )

    , stg_billing as (
        select
            workspace_id
            , cluster_id
            , owner_id
            , cluster_name
            , end_date
            , end_time
            , node_type
            , custom_tags
            , sku
            , dbus
            , dbus_unit_price
            , total_price
            , machine_hours
            , extracted_at
        from {{ ref('stg_databricks_analytics_billing') }}
    )

    , joined as (
        select
            dim_cluster.cluster_sk as cluster_fk
            , dim_sku.sku_sk as sku_fk
            , stg_billing.workspace_id
            , dim_cluster.cluster_id
            , dim_cluster.owner_id
            , dim_cluster.cluster_name
            , dim_dates.date_day
            , stg_billing.end_time
            , dim_cluster.node_type
            , dim_cluster.custom_tags
            , dim_sku.sku
            , stg_billing.dbus
            , stg_billing.dbus_unit_price
            , stg_billing.total_price
            , stg_billing.machine_hours
            , stg_billing.extracted_at
        from stg_billing
        left join dim_cluster 
            on stg_billing.cluster_id = dim_cluster.cluster_id 
            and stg_billing.node_type = dim_cluster.node_type
        left join dim_sku on stg_billing.sku = dim_sku.sku
        left join dim_dates on stg_billing.end_date = dim_dates.date_day
    )

select *
from joined
