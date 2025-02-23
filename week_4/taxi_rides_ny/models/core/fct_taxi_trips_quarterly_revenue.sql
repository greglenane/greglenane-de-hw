{{config(materialized='table')}}


with trip_data as (
    select *,
    extract(year from pickup_datetime) as pickup_year,
    extract(quarter from pickup_datetime) as pickup_quarter
    from {{ ref('fact_trips') }}
), 
trip_data_tf as (
    select 
        *,
        concat(pickup_year, '-Q', pickup_quarter) as pickup_year_quarter
    from trip_data
),
quarterly_revenue as (
    select 
        service_type,
        pickup_year,
        pickup_quarter,
        pickup_year_quarter,
        sum(total_amount) as quarterly_revenue
    from trip_data_tf
    group by
        service_type,
        pickup_year,
        pickup_quarter,
        pickup_year_quarter
),
yoy_revenue as (
    select 
        curr.service_type,
        curr.pickup_year,
        curr.pickup_quarter,
        curr.pickup_year_quarter,
        curr.quarterly_revenue,
        prev.quarterly_revenue as prev_year_revenue,
        case 
            when prev.quarterly_revenue is not null then 
                (curr.quarterly_revenue - prev.quarterly_revenue) / prev.quarterly_revenue * 100
            else null
        end as yoy_growth_percentage
    from quarterly_revenue curr
    left join quarterly_revenue prev
        on curr.service_type = prev.service_type -- Ensure comparison is within the same service type
        and curr.pickup_year = prev.pickup_year + 1 
        and curr.pickup_quarter = prev.pickup_quarter
)
select * from yoy_revenue