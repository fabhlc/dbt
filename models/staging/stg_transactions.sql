{{
    config(
        materialized='table',
        sortkey='transaction_id'
    )
}}

select * from {{ ref('transactions') }}