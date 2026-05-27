# jaffle_shop_dbt

## Overview
A dbt project built on the public [Jaffle Shop dataset](https://github.com/dbt-labs/jaffle_shop) provided by dbt Labs. The dataset is synthetic and represents a chain of restaurants (jaffle shops), modelling their locations, supplies, products, orders, and customers. It was chosen as a clean and approachable base for demonstrating slowly changing dimensions and incremental models.

## Stack
- **Warehouse:** Google BigQuery
- **Transformation:** dbt Cloud
- **Source data:** dbt Labs Jaffle Shop (loaded directly into BigQuery)

## Model Structure

```
jaffle_shop_dbt/
└── models/
    ├── staging/                      -- Rename cols, cast types, deduplicate
    └── marts/
        ├── dim_customers_scd.sql     -- Type 2 SCD, surrogate key on customer name
        └── fct_orders.sql            -- Incremental model, filtered on order_time
```

**Data flow:** Sources → Staging → Marts

| Model | Type | Key detail |
|---|---|---|
| `stg_*` | View | Cleans and harmonises raw source tables |
| `dim_customers_scd` | Table | Type 2 SCD tracking customer name changes over time |
| `fct_orders` | Incremental | Appends new rows using `order_time` as the filter predicate |

## Data Modeling Approach

### Staging Layer
Raw source tables are cleaned in the staging layer to harmonise column names, cast data types, and remove duplicates. The source data is not complex, so no intermediate layer was needed between staging and marts.

### Slowly Changing Dimension — `dim_customers_scd`
A **Type 2 SCD** is applied to the customer dimension. Because customer names can change over time, each version of a customer record is preserved with its own surrogate key. This allows downstream models and reports to join on the correct customer name as of any point in time. In a richer dataset, additional attributes prone to change (address, tier, etc.) would also be tracked here.

### Incremental Model — `fct_orders`
The orders fact table uses dbt's incremental materialisation strategy. The `order_time` column serves as the filter predicate: on each run, only rows with an `order_time` newer than the maximum already loaded are processed. This keeps run times short as the dataset grows and avoids reprocessing the full history on every execution. Use `dbt run --full-refresh` to rebuild the table from scratch if needed.
