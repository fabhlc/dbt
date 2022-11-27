{{
    config(
        materialized='view',
    )
}}


-- Pivot the data
{{ dbt_utils.unpivot(ref('packing_time_standards'), cast_to='decimal', field_name='item', value_name='standard') }}