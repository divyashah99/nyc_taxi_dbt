{% snapshot int_trip_metrics_snapshot %}

{{ 
  config(
    target_schema='snapshots',
    unique_key='trip_id',
    strategy='check',
    check_cols=[
      'fare_amount',
      'total_amount',
      'passenger_count',
      'trip_distance',
      'pickup_location_id',
      'dropoff_location_id'
    ]
  ) 
}}

select * from {{ ref('int_trip_metrics') }}

{% endsnapshot %}
