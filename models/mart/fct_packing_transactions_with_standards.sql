{{
    config(
        materialized='view'
    )
}}

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
        'FaceMasks' as item_name,
        max(case when item_name = 'Smallgood' then standard end) as standard
    from {{ ref('dim_packing_time_standards') }}
),

transactions_with_standards as (
    select 
        article.department_name                         as department_name, 
        standards.standard*cast(pack.quantity as int)   as standard_by_quantity, 
        pack.*
    from pack_transactions pack
    left join {{ ref('fct_article_master') }} article on pack.article_id = article.material_id
    left join standards on article.department_name = standards.item_name
)

select *,
    sum(standard_by_quantity) over (partition by order_number) as expected_pack_time_by_order
from transactions_with_standards

