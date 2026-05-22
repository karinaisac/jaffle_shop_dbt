# jaffle_shop_dbt

For my project, I chose a public dataset that is made available by dbt labs itself called the Jaffle Shop dataset. The dataset is a synthetic dataset that is comprised of data from a chain of jaffle shops, their locations, supplies, products, orders, and customers. I chose this dataset as a simple option to model slowly changing dimensions and to write in an incremental model.
<br>
In my project, the data was loaded into BigQuery, then connected to dbt. In dbt, the data was cleaned to harmonize column names, remove a couple unnecessary data points, and deduplicate the data. The dataset was not particularly complex, so there are only staging and mart models. 

A slowly changing dimension model was written on top of the dim_customers model to ensure that any changes in customer names over time were captured and logged with their corresponding customer key. The customer key was generated as a surrogate key to ensure each customer (or the same customer with a slightly different name) had a unique identifier. In this dataset, the data is not particularly complex, so only the customer name is something that could change over time, which would likely not be true for more complex datasets that would have more variables prone to changing over time.

The fct orders table had an incremental model written into it to ensure the performance of the model when new data came in. The variable chosen as the one to look at when running the incremental model was the order time, as this variable is the best one to signal the freshness of the data.