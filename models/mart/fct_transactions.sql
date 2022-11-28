{{
    config(
        materialized='table',
        sortkey='transaction_id'
    )
}}

select * 
from {{ ref('stg_transactions') }}