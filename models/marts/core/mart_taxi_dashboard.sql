-- {{ config(materialized='table') }}

-- with metrics as (
--     select * from {{ ref('int_trip_metrics') }}
-- ),

-- daily_summary as (
--     select
--         date(pickup_datetime) as trip_date,
--         count(*) as total_trips,
--         avg(passenger_count) as avg_passengers,
--         avg(trip_distance) as avg_distance,
--         avg(fare_amount) as avg_fare,
--         avg(trip_duration_min) as avg_duration
--     from metrics
--     group by 1
-- )

-- select * from daily_summary


{{ config(materialized='table') }}

with trip_data as (
    select * from {{ ref('int_trip_metrics') }}
),

payment_lookup as (
    select * from {{ ref('payment_types') }}
),

enhanced_trips as (
    select
        t.trip_id,
        t.vendor_id,
        t.pickup_datetime,
        t.dropoff_datetime,
        
        -- Date/Time dimensions
        EXTRACT(YEAR FROM t.pickup_datetime) as pickup_year,
        EXTRACT(MONTH FROM t.pickup_datetime) as pickup_month,
        EXTRACT(DAY FROM t.pickup_datetime) as pickup_day,
        EXTRACT(HOUR FROM t.pickup_datetime) as pickup_hour,
        EXTRACT(DAYOFWEEK FROM t.pickup_datetime) as pickup_day_of_week,
        FORMAT_DATETIME('%A', t.pickup_datetime) as pickup_day_name,
        FORMAT_DATETIME('%B', t.pickup_datetime) as pickup_month_name,
        DATE(t.pickup_datetime) as pickup_date,
        
        -- Trip metrics
        t.trip_distance,
        t.passenger_count,
        t.trip_duration_min,
        t.fare_amount,
        t.total_amount,
        t.fare_per_mile,
        
        -- Location data
        t.pickup_location_id,
        t.dropoff_location_id,
        t.pickup_zone,
        t.dropoff_zone,
        
        -- Rate and payment info
        t.rate_code,
        t.rate_code_name,
        pt.payment_type_name,
        
        -- Calculated fields for dashboard
        case 
            when t.trip_distance <= 1 then 'Short (≤1 mile)'
            when t.trip_distance <= 5 then 'Medium (1-5 miles)'
            when t.trip_distance <= 10 then 'Long (5-10 miles)'
            else 'Very Long (>10 miles)'
        end as trip_distance_category,
        
        case 
            when t.trip_duration_min <= 15 then 'Quick (≤15 min)'
            when t.trip_duration_min <= 30 then 'Medium (15-30 min)'
            when t.trip_duration_min <= 60 then 'Long (30-60 min)'
            else 'Very Long (>60 min)'
        end as trip_duration_category,
        
        case 
            when t.fare_amount <= 10 then 'Low ($0-10)'
            when t.fare_amount <= 25 then 'Medium ($10-25)'
            when t.fare_amount <= 50 then 'High ($25-50)'
            else 'Premium (>$50)'
        end as fare_category,
        
        case
            when EXTRACT(HOUR FROM t.pickup_datetime) between 6 and 9 then 'Morning Rush (6-9 AM)'
            when EXTRACT(HOUR FROM t.pickup_datetime) between 10 and 15 then 'Midday (10 AM-3 PM)'
            when EXTRACT(HOUR FROM t.pickup_datetime) between 16 and 19 then 'Evening Rush (4-7 PM)'
            when EXTRACT(HOUR FROM t.pickup_datetime) between 20 and 23 then 'Night (8-11 PM)'
            else 'Late Night/Early Morning (12-5 AM)'
        end as time_period,
        
        -- Performance metrics
        case 
            when t.trip_distance > 0 then t.total_amount / t.trip_distance 
            else null 
        end as revenue_per_mile,
        
        case 
            when t.trip_duration_min > 0 then t.total_amount / t.trip_duration_min 
            else null 
        end as revenue_per_minute,
        
        -- Tip analysis (assuming tip = total_amount - fare_amount)
        (t.total_amount - t.fare_amount) as tip_amount,
        case 
            when t.fare_amount > 0 then ((t.total_amount - t.fare_amount) / t.fare_amount) * 100 
            else 0 
        end as tip_percentage

    from trip_data t
    left join payment_lookup pt on CAST(t.payment_type_id AS STRING) = CAST(pt.payment_type_id AS STRING)
),

-- Add aggregated metrics for context
summary_stats as (
    select
        AVG(trip_distance) as avg_trip_distance,
        AVG(trip_duration_min) as avg_trip_duration,
        AVG(fare_amount) as avg_fare_amount,
        AVG(total_amount) as avg_total_amount,
        APPROX_QUANTILES(trip_distance, 2)[OFFSET(1)] as median_trip_distance,
        APPROX_QUANTILES(fare_amount, 2)[OFFSET(1)] as median_fare_amount
    from enhanced_trips
)

select 
    et.*,
    ss.avg_trip_distance,
    ss.avg_trip_duration,
    ss.avg_fare_amount,
    ss.avg_total_amount,
    ss.median_trip_distance,
    ss.median_fare_amount
from enhanced_trips et
cross join summary_stats ss