with source as (
select * 
from {{ source('jaffle_shop', 'jaffle_items') }}
),

cleaned_jaffle_items as (

select 

    string_field_0 as item_id,
    string_field_1 as order_id,
    string_field_2 as item_sku

from source 

where length(string_field_2) >= 4
)

select * from cleaned_jaffle_items