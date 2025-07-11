select *
from {{ ref('int_trip_metrics') }}
where fare_per_mile > 100
