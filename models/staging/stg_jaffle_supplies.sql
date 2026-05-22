with source as (
select * 
from {{ source('jaffle_shop', 'jaffle_supplies') }}
),

cleaned_jaffle_supplies as (

select 

   id as supply_id,
   name as supply_name,
   cost as supply_cost,
   perishable,
   sku as supply_sku

from source 
)

select * from cleaned_jaffle_supplies