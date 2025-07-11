-- tests/valid_trip_duration.sql
select *
from {{ ref('int_trip_metrics') }}
where TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) < 0
