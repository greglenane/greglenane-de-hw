# greglenane-de-hw

## Week 3
### Question 1
```
select * from myproject.raw_nyc_tripdata.ext_green_taxi
```

### Question 2
```
Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY
```

### Question 3
```
dbt run --select +models/core/
```

### Question 4
Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile
When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET
When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

### Question 5
dbt model: https://github.com/greglenane/greglenane-de-hw/blob/main/week_4/taxi_rides_ny/models/core/fct_taxi_trips_quarterly_revenue.sql
```
select
service_type,
pickup_year_quarter, 
yoy_growth_percentage
from `ny-rides-gregl-446219.prod_dbt.fct_taxi_trips_quarterly_revenue`
where pickup_year = 2020
order by service_type, yoy_growth_percentage;
```
ANSWER: green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}

### Question 6
dbt model: https://github.com/greglenane/greglenane-de-hw/blob/main/week_4/taxi_rides_ny/models/core/fct_taxi_trips_monthly_fare_p95.sql
```
SELECT * from `ny-rides-gregl-446219.prod_dbt.fct_taxi_trips_monthly_fare_p95`
WHERE 
pickup_month = 4 AND
pickup_year = 2020;
```
ANSWER: green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}

### Question 7
dbt models:
https://github.com/greglenane/greglenane-de-hw/blob/main/week_4/taxi_rides_ny/models/staging/stg_fhv_data.sql
https://github.com/greglenane/greglenane-de-hw/blob/main/week_4/taxi_rides_ny/models/core/dim_fhv_trips.sql
https://github.com/greglenane/greglenane-de-hw/blob/main/week_4/taxi_rides_ny/models/core/fct_fhv_monthly_zone_traveltime_p90.sql
```
select distinct
pickup_zone,
dropoff_zone,
p90
from `ny-rides-gregl-446219.prod_dbt.fct_fhv_monthly_zone_traveltime_p90`
where pickup_zone = 'Newark Airport' AND
pickup_year = 2019 AND
pickup_month = 11
order by p90 desc;

select distinct
pickup_zone,
dropoff_zone,
p90
from `ny-rides-gregl-446219.prod_dbt.fct_fhv_monthly_zone_traveltime_p90`
where pickup_zone = 'SoHo' AND
pickup_year = 2019 AND
pickup_month = 11
order by p90 desc;

select distinct
pickup_zone,
dropoff_zone,
p90
from `ny-rides-gregl-446219.prod_dbt.fct_fhv_monthly_zone_traveltime_p90`
where pickup_zone = 'Yorkville East' AND
pickup_year = 2019 AND
pickup_month = 11
order by p90 desc;
```
ANSWER: LaGuardia Airport, Chinatown, Garment District
