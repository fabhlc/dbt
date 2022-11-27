{{
    config(
        materialized='view',
        sortkey='item'
    )
}}
with pivoted as (
    {{ dbt_utils.unpivot(ref('packing_time_standards'), cast_to='decimal', field_name='item', value_name='standard') }}
)

select 
    initcap(left(item, length(item)-length('_STANDARD'))) as item_name, -- format item name for join
    item,
    standard
from pivoted 
order by item asc