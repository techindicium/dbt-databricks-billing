with
    sku_pricing as (
        select
            account_id
            , price_start_time
            , price_end_time
            , sku
            , cloud
            , currency_code
            , dbu_unit
            , dbus_default_unit_price
            , dbus_promotional_unit_price
            , dbus_effective_unit_price
        from {{ ref('stg_databricks_analytics_pricing') }}
    )

    , sku_pricing_sk as (
        select
            {{ dbt_utils.generate_surrogate_key([
                'account_id'
                , 'price_start_time'
                , 'price_end_time'
                , 'sku'
                , 'cloud'
            ]) }} as sku_pricing_sk
            , account_id
            , price_start_time
            , price_end_time
            , sku
            , cloud
            , currency_code
            , dbu_unit
            , dbus_default_unit_price
            , dbus_promotional_unit_price
            , dbus_effective_unit_price
        from sku_pricing
    )
    
select *
from sku_pricing_sk
