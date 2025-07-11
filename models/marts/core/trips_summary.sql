{{ config(materialized='table') }}

with metrics as (
    select * from {{ ref('int_trip_metrics') }}
),

daily_summary as (
    select
        date(pickup_datetime) as trip_date,
        count(*) as total_trips,
        avg(passenger_count) as avg_passengers,
        avg(trip_distance) as avg_distance,
        avg(fare_amount) as avg_fare,
        avg(trip_duration_min) as avg_duration
    from metrics
    group by 1
)

select * from daily_summary
