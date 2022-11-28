{{
    config(
        materialized='view',
        sortkey='material_id'
    )
}}

select 
    cast(material as string) as material_id,
    department
from {{ ref('article_master') }}
