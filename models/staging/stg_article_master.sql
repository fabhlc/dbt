{{
    config(
        materialized='table',
        sortkey='material'
    )
}}

select 
    material,
    department
from {{ ref('article_master') }}
