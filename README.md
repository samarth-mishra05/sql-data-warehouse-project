# Data Warehouse & Analytics — PostgreSQL

This project is an end-to-end data warehouse built to simulate a real-world data engineering workflow.

The objective was to take raw data from two source systems (CRM and ERP), load it into PostgreSQL, clean and standardize it, and model it into a structure suitable for analytical reporting using Python and SQL only.

---

## Architecture

The warehouse follows a **Medallion Architecture** approach:

### Bronze (Raw Layer)
- Ingests CSV files into PostgreSQL
- Loaded using Python (`psycopg2`) and `COPY`
- Basic ETL logging added to track load duration

### Silver (Clean Layer)
- Deduplication using window functions
- Data standardization and normalization
- Business rule application
- Data quality validation scripts

### Gold (Analytics Layer)
- Star Schema design:
  - `dim_customers`
  - `dim_products`
  - `fact_sales`
- Designed for straightforward analytical queries

---

## Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL based reports and dashboards for actionable insights.
   
---

## Why Star Schema?

The focus of this project is analytical querying and reporting.  
A Star Schema simplifies joins, improves readability, and keeps queries efficient. Since the scope is latest-state reporting, denormalized dimensions were appropriate.

---

## Tech Stack

- **PostgreSQL** — primary data store and transformation engine
- **Python + psycopg2** — ETL orchestration and data loading
- **SQL** — transformations, modeling, and analytics
- **Medallion Architecture** — Bronze / Silver / Gold layering
- **Star Schema** — dimensional model for the Gold layer

---

## About Me

Hi there! I'm **Samarth Mishra**. I’m a pre final year Computer Science and Engineering Student.

Let's stay in touch! Feel free to connect with me on the following platforms:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samarthmishra35/) [![GitHub](https://img.shields.io/badge/GitHub-232925?style=for-the-badge&logo=GitHub&logoColor=white)](https://github.com/samarth-mishra05)


