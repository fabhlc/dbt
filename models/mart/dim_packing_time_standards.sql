{{
    config(
        materialized='table',
        sortkey='item_name'
    )
}}

select 
    initcap(left(item, length(item)-length('_STANDARD'))) as item_name, -- format item name for join, remove trailing _STANDARD
    item,
    standard
from {{ ref('stg_packing_time_standards') }} 
order by item asc