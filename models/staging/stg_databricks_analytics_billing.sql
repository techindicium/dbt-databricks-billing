with
    renamed as (
        select
            workspaceid as workspace_id
            , clusterid as cluster_id
            , clusterowneruserid owner_id
            , cast(clustername as string) as cluster_name
            , cast(timestamp as date) as end_date
            , substring(timestamp, 12, 8) as end_time
            , cast(clusternodetype as string) as node_type
            , cast(clustercustomtags as string) as custom_tags
            , cast(sku as string) as sku
            , round(dbus,2) as dbus
            , round(machinehours,2) as machine_hours
            , _SDC_EXTRACTED_AT as extracted_at
        from {{ source('raw_databricks', 'billing') }}
    )

    , case_when as (
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
            , case
                  when sku = 'STANDARD_ALL_PURPOSE_COMPUTE' then 0.55
                  when sku = 'STANDARD_DLT_CORE_COMPUTE' then 0.20
                  when sku = 'STANDARD_DLT_ADVANCED_COMPUTE' then 0.36
                  when sku = 'STANDARD_JOBS_COMPUTE' then 0.15
                  when sku = 'STANDARD_ALL_PURPOSE_COMPUTE_(PHOTON)' then 0.55
                  else null
            end as dbus_unit_price
            , machine_hours
            , extracted_at
        from renamed
    )

    , calculate as (
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
            , (dbus * dbus_unit_price) as total_price
            , machine_hours
            , extracted_at
        from case_when
    )

select *
from calculate