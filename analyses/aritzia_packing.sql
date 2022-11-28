-- # of transactions are packing transactions
-- select 
--     count(*) as total, 
--     sum(case when action_code = 'PKOCLOSE' then 1 else 0 end) as packs
-- from ref('fct_transactions') }}  

-- Days of Data
-- select min(date) as min_date, max(date) as max_date from ref('fct_transactions') }}



select
    user_id,
    count(*)            as transactions,
    sum(standard)       as total_time_secs,
    sum(standard)/60.0  as total_time_mins,
from {{ ref('fct_transactions_with_standards') }}
group by 1
order by transactions desc 

