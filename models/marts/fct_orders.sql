{{config(
materialized='incremental',
unique_key='order_id')
}}

with stg_orders as (
select * 
from {{ ref('stg_jaffle_orders') }}
),

final as (
select
    order_id,
    customer_id,
    store_id,
    ordered_at,
    subtotal,
    tax_paid,
    order_total
from stg_orders

    {% if is_incremental() %}

        where ordered_at > (
            select max(ordered_at)
            from {{ this }}
        )
    {% endif %}
)

select * from final