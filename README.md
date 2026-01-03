# Social Media Addiction Data Warehouse (dbt + Snowflake)

## Overview

This project implements an end-to-end **analytics data warehouse** for analyzing social media usage patterns and their relationship to sleep, mental health, and academic performance among students aged 16–25.

The project emphasizes **data modeling, data quality, and transformation correctness**, rather than dashboarding. The warehouse applies the **Medallion Architecture (Bronze → Silver → Gold)** and **Kimball dimensional modeling** to produce analytics-ready data that can be reliably consumed by BI tools.

---

## Architecture

The pipeline follows a **Bronze → Silver → Gold** architecture:

### Bronze
- Raw survey data ingested into Snowflake  
- No transformations applied  

### Silver
- Cleaned and standardized data  
- Explicit type casting and normalization  
- Data quality enforcement (ranges, nullability, uniqueness)  

### Gold
- Analytics-ready star schema  
- Dimension and fact tables designed for efficient querying  
- Enforced referential integrity between facts and dimensions  

Pipeline execution and dependencies between ingestion and transformation are orchestrated using Dagster.

---

## Data Model

### Fact Table
**`fact_students_usage`**

- Grain: **one survey response per student**
- Measures:
  - Average daily social media usage
  - Sleep hours per night
  - Mental health score
  - Addiction score
  - Conflicts over social media
  - Academic performance impact (binary)

### Dimensions
- **`dim_student`** — demographic and academic attributes  
- **`dim_platform`** — social media platforms  
- **`dim_date`** — date derived from ingestion timestamp  

Facts reference dimensions using **surrogate keys**, resulting in a clean and extensible star schema.

---

## Key Design Decisions

- Deterministic surrogate key generation for stable joins  
- Inner joins between facts and dimensions to enforce integrity  
- Gold models materialized as **tables** for predictable performance  
- Business logic centralized in dbt models, not downstream tools
- Date dimension derived from ingestion timestamp due to absence of event-level business dates

---

## Data Quality & Testing

Correctness is enforced using **dbt tests**:

- `not_null` and `unique` constraints  
- Accepted ranges for numeric measures  
- Referential integrity tests between fact and dimension tables  

Testing is applied per layer, with strict validation at the Gold layer.

---

## Analytics & Power BI

Power BI is used strictly as a **consumer** of the Gold layer.

- Direct connection to Snowflake  
- Star schema enables simple, performant slicing and aggregation  
- Metrics are defined in the warehouse, not in Power BI  

No transformation or business logic is implemented in dashboards.

---

## Tech Stack

- **Snowflake** — cloud data warehouse  
- **dbt** — transformations, testing, modeling  
- **SQL** — transformation logic  
- **Azure Blob Storage** — raw file storage for source data  
- **Airbyte** — ingestion from Blob Storage into Snowflake
- **Dagster** — orchestration of Airbyte ingestion and dbt transformations
- **Power BI** — analytics consumption  

---

## What This Project Demonstrates

- Designing a warehouse from raw ingestion to analytics-ready models  
- Applying dimensional modeling correctly  
- Enforcing data quality through automated testing  
- Separating transformation logic from analytics tools  
- Building a maintainable, BI-friendly data warehouse  

---

## Notes

This repository focuses on **data engineering fundamentals**: modeling, correctness, and maintainability. Visualization is intentionally secondary and exists only to consume validated warehouse outputs.
