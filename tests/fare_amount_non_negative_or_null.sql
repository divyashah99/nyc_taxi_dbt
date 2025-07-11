SELECT *
FROM {{ ref('stg_taxi_trips') }}
WHERE NOT (fare_amount >= 0 OR fare_amount IS NULL)
