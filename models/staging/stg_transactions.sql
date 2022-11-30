{{
    config(
        materialized='view',
        sortkey='transaction_id'
    )
}}

select 
    transaction_id,
    warehouse_id,
    transaction_timestamp as transaction_timestamp_raw,
    datetime(cast(left(transaction_timestamp, 18) as timestamp), "UTC") as transaction_timestamp_fmt, -- assumption: data only contains AM dates.
    date,
    hour,
    order_type,
    order_type_category,
    order_channel,
    user_id,
    action_code,
    order_number,
    order_line_item,
    cast(article as string) as article_id,
    device_code,
    ship_line_id,
    gift_flag,
    from_area_code,
    from_storage_location,
    to_storage_location,
    order_category,
    inventory_detail_number,
    quantity
from {{ ref('transactions') }}
