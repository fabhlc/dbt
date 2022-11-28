-- # of transactions are packing transactions
-- select 
--     count(*) as total, 
--     sum(case when action_code = 'PKOCLOSE' then 1 else 0 end) as packs
-- from ref('fct_transactions') }}  

-- Days of Data
-- select min(date) as min_date, max(date) as max_date from ref('fct_transactions') }}


with packing as (
    select * from {{ ref('fct_transactions') }}
    where action_code = 'PKOCLOSE' 
)

select article.department, packing.* from packing 
left join {{ ref('fct_article_master') }} article on packing.article = article.material
-- group by 1 order by 2 desc


