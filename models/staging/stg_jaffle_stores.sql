with source as (
select * 
from {{ source('jaffle_shop', 'jaffle_stores') }}
),

cleaned_jaffle_stores as (

select 

    id as store_id,
    name as store_name,
    opened_at as store_opened_at,
    tax_rate as store_tax_rate

from source 
)

select * from cleaned_jaffle_stores