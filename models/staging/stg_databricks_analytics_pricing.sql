with
    source as (
        select *
        from {{ source('raw_system_tables_databricks', 'list_prices') }}
    )

    , renamed as (
        select
            cast(account_id as string) as account_id
            , cast(price_start_time as timestamp) as price_start_time
            , cast(price_end_time as timestamp) as price_end_time
            , cast(sku_name as string) as sku
            , cast(cloud as string) as cloud
            , cast(currency_code as string) as currency_code
            , cast(usage_unit as string) as dbu_unit
            , round(pricing.default, 2) as dbus_default_unit_price
            , round(pricing.promotional.default, 2) as dbus_promotional_unit_price
            , round(pricing.effective_list.default, 2) as dbus_effective_unit_price
        from source
    )

select *
from renamed
