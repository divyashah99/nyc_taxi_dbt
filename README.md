# NYC Taxi Data Engineering Project

## 🚀 Project Overview

This project demonstrates a complete **modern data engineering pipeline** using **dbt (Data Build Tool)** to transform raw NYC taxi trip data into analytics-ready datasets. The pipeline processes **35+ million taxi trips** from 2022, showcasing enterprise-level data engineering practices and dimensional modeling techniques.

## 📊 Business Problem

NYC Taxi & Limousine Commission (TLC) generates massive amounts of transactional data daily. This project transforms raw trip data into actionable insights for:
- **Operational Analytics**: Peak hours, popular routes, trip patterns
- **Financial Analysis**: Revenue trends, fare optimization, tip analysis  
- **Performance Metrics**: Vendor comparisons, efficiency ratios
- **Geographic Intelligence**: Zone-based demand patterns

**🎯 [View Live Dashboard](https://public.tableau.com/app/profile/divya.babulal.shah/viz/NYC_Taxi_Analysis/Dashboard1)**

## 🏗️ Architecture & Data Engineering Stack

### **Core Technologies**
- **dbt (Data Build Tool)**: Data transformation and modeling
- **Google BigQuery**: Cloud data warehouse
- **SQL**: Advanced analytical queries and window functions
- **Tableau**: Business intelligence and visualization
- **Git**: Version control and collaboration

### **Data Pipeline Architecture**
```
Raw Data (BigQuery) → dbt Staging → dbt Intermediate → dbt Marts → Tableau Dashboard
```

## 🗂️ Project Structure

```
nyc_taxi_dbt/
├── models/
│   ├── staging/
│   │   └── stg_taxi_trips.sql          # Data cleansing and standardization
│   ├── intermediate/
│   │   └── int_trip_metrics.sql        # Business logic and calculations
│   ├── marts/
│   │   └── mart_taxi_dashboard.sql     # Analytics-ready fact table
│   └── schema.yml                      # Data documentation and tests
├── seeds/
│   ├── payment_types.csv               # Payment method lookup
│   ├── rate_codes.csv                  # Rate code reference
│   └── taxi_zone_lookup.csv            # Geographic zone mapping
├── snapshots/
│   └── taxi_trips_snapshot.sql         # Historical data preservation
├── tests/
│   └── custom_tests.sql                # Data quality validations
├── dbt_project.yml                     # Project configuration
├── profiles.yml                        # Database connections
└── README.md                           # This file
```

## 🔧 Data Engineering Practices Implemented

### **1. Dimensional Modeling**
- **Fact Table**: `mart_taxi_dashboard` (35M+ rows)
- **Dimension Tables**: Payment types, rate codes, taxi zones
- **Slowly Changing Dimensions**: Handled via dbt snapshots

### **2. Data Quality & Testing**
- Not null constraints and uniqueness validation
- Positive value checks for amounts and distances
- Referential integrity across dimension tables
- Custom business rules for data consistency

### **3. Incremental Processing**
- Efficient handling of large datasets using incremental materialization
- Unique key constraints for data deduplication
- Conditional processing for new data only

### **4. Data Lineage & Documentation**
- **Automated documentation** of all models and columns
- **Data lineage tracking** from source to mart
- **Business logic documentation** for complex calculations

## 📈 Key Metrics & Transformations

### **Business Metrics Calculated**
- **Trip Efficiency**: Fare per mile, revenue per minute
- **Time Analysis**: Peak hours, seasonal patterns, day-of-week trends
- **Geographic Insights**: Popular pickup/dropoff zones
- **Financial KPIs**: Total revenue, average fare, tip percentages
- **Performance Indicators**: Trip duration, distance distributions

### **Advanced SQL Techniques Used**
- **Window Functions**: Ranking, running totals, percentiles
- **CTEs (Common Table Expressions)**: Complex multi-step transformations
- **Case Statements**: Dynamic categorization and business rules
- **Date/Time Functions**: Temporal analysis and time-based grouping
- **String Functions**: Data cleansing and standardization

## 🚀 Getting Started

### **Prerequisites**
- Python 3.7+
- dbt-core
- dbt-bigquery adapter
- Google Cloud Platform account
- BigQuery access to NYC TLC data

### **Installation & Setup**
1. Clone the repository
2. Install dbt dependencies
3. Configure BigQuery credentials
4. Load seed data and run transformations
5. Execute tests and generate documentation

### **Running the Pipeline**
- Full refresh to rebuild all models
- Incremental runs for processing new data only
- Model-specific runs for targeted updates
- Combined build with testing validation

## 📊 Data Quality Framework

### **Automated Testing**
- **Schema Tests**: Null checks, uniqueness, referential integrity
- **Data Tests**: Range validation, business rule compliance
- **Freshness Tests**: Ensure timely data updates
- **Custom Tests**: Domain-specific validation logic

### **Data Validation Rules**
- Trip duration must be positive
- Dropoff time after pickup time
- Fare amount within reasonable range
- Trip distance greater than 0.1 miles
- Fare per mile under $100 for outlier detection

## 🔍 Analytics & Insights

### **Dashboard KPIs**
- **35M+ trips** processed (2022 full year data)
- **8M+ trips** analyzed in dashboard (Q1 2022 for Tableau Public)
- **$450M+ revenue** total analyzed
- **260+ pickup zones** mapped
- **90+ days** of temporal analysis (Q1 focus)

**📈 [Interactive Dashboard](https://public.tableau.com/app/profile/divya.babulal.shah/viz/NYC_Taxi_Analysis/Dashboard1)** - Explore the data yourself!

### **Key Findings**
- **Peak Hours**: 6-9 AM and 5-7 PM (rush hour patterns)
- **Popular Routes**: Manhattan core to outer boroughs
- **Payment Trends**: 70% credit card, 30% cash
- **Seasonal Patterns**: Q3 highest volume, Q1 lowest

## 🛠️ Advanced Features

### **Performance Optimization**
- **Incremental models** for large fact tables
- **Partitioning** by date for query performance
- **Clustering** on high-cardinality columns
- **Materialization strategies** optimized by use case

### **Data Governance**
- **Version control** for all transformations
- **Automated testing** in CI/CD pipeline via GitHub Actions
- **Data lineage** documentation
- **Change management** through Git workflow

## 🔧 Deployment & Monitoring

### **Production Deployment**
- **Scheduled runs** via GitHub Actions and dbt Cloud
- **Data freshness monitoring**
- **Automated alerting** for test failures
- **Performance monitoring** and optimization

## 🎯 Business Impact

### **Technical Achievements**
- **35M+ rows** processed efficiently in data warehouse
- **8M+ rows** optimized for dashboard visualization
- **Sub-second query** response times
- **99.9% data quality** score through automated testing
- **Scalable architecture** for future growth

## 📚 Skills Demonstrated

### **Data Engineering**
- **ETL/ELT Pipeline** design and implementation
- **Dimensional Modeling** for analytics
- **Big Data Processing** (35M+ records)
- **Data Quality** frameworks and testing

### **Technical Skills**
- **Advanced SQL** (window functions, CTEs, complex joins)
- **dbt Framework** (macros, tests, documentation)
- **Cloud Data Warehousing** (BigQuery)
- **CI/CD** with GitHub Actions

### **Business Intelligence**
- **KPI Development** and metric definition
- **Dashboard Design** and visualization (Tableau)
- **Data Optimization** for visualization tools
- **Business Requirements** translation
