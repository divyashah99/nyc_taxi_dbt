{{ config(materialized='incremental', unique_key='trip_id') }}

with trips as (
    select * from {{ ref('stg_taxi_trips') }}
),

trip_with_lookups as (
    select
        t.*,
        rc.rate_code_name,
        pu.zone as pickup_zone,
        do.zone as dropoff_zone,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) as trip_duration_min,
        case
            when trip_distance = 0 or trip_distance is null then null
            else fare_amount / trip_distance
        end as fare_per_mile,
        TO_HEX(
  MD5(
    TO_JSON_STRING(
      STRUCT(
        vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        fare_amount,
        total_amount,
        pickup_location_id,
        dropoff_location_id
      )
    )
  )
) as trip_id

    
    from {{ ref('stg_taxi_trips') }} t
    left join {{ ref('rate_codes') }} rc
  on CAST(t.rate_code AS STRING) = CAST(rc.rate_code_id AS STRING)

left join {{ ref('taxi_zone_lookup') }} pu
  on CAST(t.pickup_location_id AS STRING) = CAST(pu.LocationID AS STRING)

left join {{ ref('taxi_zone_lookup') }} do
  on CAST(t.dropoff_location_id AS STRING) = CAST(do.LocationID AS STRING)

)

select * from trip_with_lookups 

{% if is_incremental() %}

where (pickup_datetime > (select max(pickup_datetime) from {{ this }}))

{% endif %}
