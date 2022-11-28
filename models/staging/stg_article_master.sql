{{
    config(
        materialized='view',
        sortkey='material_id'
    )
}}

select 
    cast(material as string)        as material_id,
    replace(department, '-', '')    as department_name
from {{ ref('article_master') }}
