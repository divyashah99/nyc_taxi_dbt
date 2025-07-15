{{ config(materialized='table') }}

select * from {{ ref('mart_taxi_dashboard') }}
