with
    sku as (
        select distinct
            sku
            , dbus_unit_price
        from {{ ref('stg_databricks_analytics_billing') }}
    )

    , sku_sk as (
        select
            {{ dbt_utils.generate_surrogate_key(['sku']) }} as sku_sk
            , sku
            , dbus_unit_price
        from sku
    )
    
select *
from sku_sk