-- # of transactions are packing transactions
-- select 
--     count(*) as total, 
--     sum(case when action_code = 'PKOCLOSE' then 1 else 0 end) as packs
-- from ref('fct_transactions') }}  

-- Days of Data
-- select min(date) as min_date, max(date) as max_date from ref('fct_transactions') }}


with tmp as (
    select
        user_id,
        count(*)            as transactions,
        sum(standard_by_quantity)       as total_time_secs,
        sum(standard_by_quantity)/60.0  as total_time_mins,
        min(transaction_timestamp) as start_time
    from {{ ref('fct_transactions_with_standards') }}
    group by 1
    order by transactions desc 
),

overall as (
    select
        user_id,
        count(*)            as all_transactions,
        min(transaction_timestamp) as start_time
    from {{ ref('fct_transactions') }}
    group by 1
)


select
    tmp.*,
    overall.all_transactions
from tmp left join overall on tmp.user_id = overall.user_id
order by transactions desc
