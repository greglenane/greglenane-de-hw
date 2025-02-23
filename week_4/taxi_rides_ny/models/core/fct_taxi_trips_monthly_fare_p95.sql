{{config(materialized='table')}}

with trip_data as (
    select *,
    extract(month from pickup_datetime) as pickup_month,
    extract(year from pickup_datetime) as pickup_year
    from {{ ref('fact_trips') }}
    where 
        fare_amount > 0 and
        trip_distance > 0 and
        payment_type_description IN ('Cash', 'Credit card')
        
), trip_data_percentile as (
    select distinct
    service_type,
    pickup_year,
    pickup_month,
    percentile_cont(fare_amount, 0.97) over(partition by service_type, pickup_year, pickup_month) as p97,
    percentile_cont(fare_amount, 0.95) over(partition by service_type, pickup_year, pickup_month) as p95,
    percentile_cont(fare_amount, 0.90) over(partition by service_type, pickup_year, pickup_month) as p90
    from trip_data
)
select * from trip_data_percentile