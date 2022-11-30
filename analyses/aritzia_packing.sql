-- # of transactions are packing transactions
-- select 
--     count(*) as total, 
--     sum(case when action_code = 'PKOCLOSE' then 1 else 0 end) as packs
-- from ref('fct_transactions') }}  

-- Days of Data
-- select min(date) as min_date, max(date) as max_date from ref('fct_transactions') }}


-- with tmp as (
--     select
--         user_id,
--         count(*)            as transactions,
--         sum(standard_by_quantity)       as total_time_secs,
--         sum(standard_by_quantity)/60.0  as total_time_mins,
--         min(transaction_timestamp) as start_time
--     from ref('fct_packing_transactions_with_standards') }}
--     group by 1
--     order by transactions desc 
-- ),

-- overall as (
--     select
--         user_id,
--         count(*)            as all_transactions,
--         min(transaction_timestamp) as start_time
--     from ref('fct_transactions') }}
--     group by 1
-- )

-- select
--     tmp.*,
--     overall.all_transactions
-- from tmp left join overall on tmp.user_id = overall.user_id
-- order by transactions desc



-- actuals vs kpis for users
with order_pack_times as (
    select *,
        avg(case when time_over_kpi > 0.0 then time_over_kpi else null end) over () as overall_avg_overtime_sec,
        total_order_time_actual/total_order_time_expected as overall_overtime_pct
    from (
        select 
            -- (select * would also work, but these columns are brought in for personal ease of troubleshooting)
            user_id, 
            order_number, 
            transaction_timestamp_fmt, 
            next_transaction_timestamp, 
            order_line_item, 
            actual_order_time, 
            expected_pack_time_by_order, 
            quantity, 
            department_name,
            actual_order_time - expected_pack_time_by_order as time_over_kpi,
            sum(actual_order_time) over () as total_order_time_actual,
            sum(expected_pack_time_by_order) over () total_order_time_expected
        from  {{ ref('fct_packing_transactions_with_standards') }}
        where order_line_item = 1 
        order by user_id, transaction_timestamp_fmt asc
    )
)

select *,
    avg_overtime_sec/60.0 as avg_overtime_min,
    num_orders_overtime/num_of_orders as pct_of_orders_overtime
from (
    select
        user_id,
        count(*) as num_of_orders,
        sum(case when time_over_kpi > 0.0 then 1 else 0 end) as num_orders_overtime,
        avg(case when time_over_kpi > 0.0 then time_over_kpi else null end) as avg_overtime_sec,
        sum(actual_order_time)/sum(expected_pack_time_by_order) as overtime_pct,
        min(overall_avg_overtime_sec) as overall_avg_overtime_sec
    from order_pack_times 
    group by user_id
)
order by num_of_orders desc



-- -- Does bundle size impact overtime risk? -- No
-- with tmp2 as (
--     select 
--         order_number,
--         sum(cast(quantity as int)) as number_of_items_in_bundle,
--         max(expected_pack_time_by_order) as expected_pack_time_bundle,
--         sum(actual_order_time) as actual_pack_time
--     from {{ ref('fct_packing_transactions_with_standards') }}
--     group by order_number)

-- select 
--     number_of_items_in_bundle, 
--     sum(actual_pack_time)/sum(expected_pack_time_bundle) as pct 
-- from tmp2 
-- group by number_of_items_in_bundle
-- order by 1 asc