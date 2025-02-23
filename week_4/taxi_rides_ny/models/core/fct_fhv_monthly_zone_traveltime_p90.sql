{{config(materialized='table')}}

with fhv_dim as (
    select *,
    timestamp_diff(dropoff_datetime, pickup_datetime,  second) as trip_duration
    from {{ ref('dim_fhv_trips') }}
)
select distinct
pickup_year,
pickup_month,
pulocationid,
pickup_borough,
pickup_zone,
dolocationid,
dropoff_borough,
dropoff_zone,
trip_duration,
percentile_cont(trip_duration, 0.90) over(partition by pickup_year, pickup_month, pulocationid, dolocationid) as p90
from fhv_dim