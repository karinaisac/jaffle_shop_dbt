with source as (
select * 
from {{ source('jaffle_shop', 'jaffle_products') }}
),

cleaned_jaffle_products as (

select 

    sku as product_sku,
    name as product_name,
    type as product_type,
    price as product_price,
    description as product_description

from source 
)

select * from cleaned_jaffle_products