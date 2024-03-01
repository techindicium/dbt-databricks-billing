with
    cluster as (
        select distinct
            cluster_id
            , cluster_name
            , owner_id
            , node_type
            , custom_tags
        from {{ ref('stg_databricks_analytics_billing') }}
    )

    , cluster_sk as (
        select
            {{ dbt_utils.generate_surrogate_key(['cluster_id','node_type']) }} as cluster_sk
            , cluster_id
            , cluster_name
            , owner_id
            , node_type
            , custom_tags
        from cluster
    )
    
select *
from cluster_sk