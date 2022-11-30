{{
    config(
        materialized='table',
        sortkey='transaction_id'
    )
}}


select 
    *, 
    TIMESTAMP_DIFF(next_transaction_timestamp, transaction_timestamp_fmt, SECOND) as actual_order_time 
from (
    select *,
        -- get next timestamp; stabilize timestamp to first order_line_item for easy access downstream
        lead(transaction_timestamp_fmt) over (partition by user_id order by transaction_timestamp_fmt asc, order_line_item desc) as next_transaction_timestamp, 
    from {{ ref('stg_transactions') }}
)
order by user_id, transaction_timestamp_fmt asc
