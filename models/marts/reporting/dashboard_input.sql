{{ config(materialized='table') }}

select * from {{ ref('trips_summary') }}
