{{config(materialized='table')}}

with fhv_trips as (
    select *,
    extract(year from pickup_datetime) as pickup_year,
    extract(month from pickup_datetime) as pickup_month
    from {{ ref('stg_fhv_data') }}
), dim_zones as (
    select
    cast(locationid as string) as locationid,
    borough,
    zone,
    service_zone
    from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
fhv.unique_row_id,
fhv.filename,
fhv.dispatching_base_num,
fhv.pickup_datetime,
fhv.pickup_year,
fhv.pickup_month,
fhv.dropoff_datetime,
fhv.pulocationid,
pickup_zone.borough as pickup_borough, 
pickup_zone.zone as pickup_zone,
fhv.dolocationid,
dropoff_zone.borough as dropoff_borough, 
dropoff_zone.zone as dropoff_zone,
fhv.sr_flag,
fhv.affiliated_base_number
from fhv_trips fhv
inner join dim_zones as pickup_zone
on fhv.pulocationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv.dolocationid = dropoff_zone.locationid