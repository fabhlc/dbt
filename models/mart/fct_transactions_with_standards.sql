{{
    config(
        materialized='view'
    )
}}

-- For the purposes of the assignment, this SQL script is a model. In practice, this analysis should be in a BI tools.

with pack_transactions as (
    select * 
    from {{ ref('fct_transactions') }}
    where action_code = 'PKOCLOSE' 
),

standards as (
    select 
        item_name,
        standard
    from {{ ref('dim_packing_time_standards') }}
     
    union all
    
    select 
        'Face Masks' as item_name,
        max(case when item_name = 'Smallgood' then standard end) as standard
    from {{ ref('dim_packing_time_standards') }}
),

transactions_with_standards as (
    select 
        article.department_name, 
        standards.standard, 
        pack.* 
    from pack_transactions pack
    left join {{ ref('fct_article_master') }} article on pack.article_id = article.material_id
    left join standards on article.department_name = standards.item_name
)

select * from transactions_with_standards