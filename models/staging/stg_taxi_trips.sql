{{ config(materialized='view') }}

select
  vendor_id,
  pickup_datetime,
  dropoff_datetime,
  trip_distance,
  CAST(coalesce(passenger_count, 0) AS INT64) as passenger_count,
  fare_amount,
  total_amount,
  pickup_location_id,
  dropoff_location_id,
  rate_code
from {{ source('taxi_data', 'tlc_yellow_trips_2022') }}
where dropoff_datetime >= pickup_datetime
AND fare_amount >= 0
AND total_amount >= 0
AND trip_distance >= 0.1
AND fare_amount / NULLIF(trip_distance, 0) < 100