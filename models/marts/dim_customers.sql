with stg_customers as (
    select * 
    from {{ ref('stg_jaffle_customers') }}
),

deduplicated as (
select *,
    row_number() over (partition by customer_id order by (select null)) as row_num
from stg_customers
),

filtered as (
select
    customer_id,
    customer_name
from deduplicated

where row_num = 1
),

scd as (
select
    customer_id,
    customer_name,
    current_date() as valid_from,
    cast(null as date) as valid_to,
    true as is_current,
    to_hex(md5(concat(
            cast(customer_id as string),
            '|',
            coalesce(customer_name, '')
        ))) as customer_key

    from filtered
)

select * from scd