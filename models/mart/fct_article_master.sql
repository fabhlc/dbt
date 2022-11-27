{{
    config(
        materialized='table'
    )
}}


select * from {{ ref('stg_article_master') }}