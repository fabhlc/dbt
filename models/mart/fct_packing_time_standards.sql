{{
    config(
        materialized='table',
        sortkey='material'
    )
}}

select * from {{ ref('stg_packing_time_standards') }}