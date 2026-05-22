with source as (
select * 
from {{ source('jaffle_shop', 'jaffle_orders') }}
),

cleaned_jaffle_orders as (

select 
    id as order_id,
    customer as customer_id,
    ordered_at,
    store_id,
    subtotal,
    tax_paid,
    order_total
from source 
)

select * from cleaned_jaffle_orders