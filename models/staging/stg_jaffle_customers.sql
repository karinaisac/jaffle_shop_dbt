with source as (
select * 
from {{ source('jaffle_shop', 'jaffle_customers') }}
),

deduplicated as (

select *,
    row_number() over (partition by string_field_1 order by string_field_0 desc) as row_num
from source
),

cleaned_jaffle_customers as (

    select
        string_field_0 as customer_id,
        string_field_1 as customer_name

    from deduplicated
    where row_num = 1  

)

select * from cleaned_jaffle_customers