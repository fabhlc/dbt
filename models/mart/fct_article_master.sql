{{
    config(
        materialized='table',
        sortkey='material_id'
    )
}}

select * from {{ ref('stg_article_master') }}

