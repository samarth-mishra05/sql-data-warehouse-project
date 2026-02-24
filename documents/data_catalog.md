# Data Catalog – Gold Layer

## Overview
The Gold Layer represents the business-ready analytical model of the data warehouse.  
It is structured using a star schema and consists of **dimension tables** and **fact tables** designed to support reporting and analytics use cases.

---

## 1. gold.dim_customers

**Purpose:**  
Stores consolidated and enriched customer information for analytical reporting.

**Primary Key:** `customer_key` (Surrogate Key)

| Column Name     | Data Type     | Description |
|---------------|--------------|------------|
| customer_key  | INT          | Surrogate key uniquely identifying each customer record. |
| customer_id   | INT          | Business key identifying the customer from the source system. |
| customer_number | VARCHAR(50) | Alphanumeric customer identifier used for tracking. |
| first_name    | VARCHAR(50)  | Customer’s first name. |
| last_name     | VARCHAR(50)  | Customer’s last name. |
| country       | VARCHAR(50)  | Standardized country name of residence. |
| marital_status| VARCHAR(50)  | Normalized marital status (e.g., Married, Single, n/a). |
| gender        | VARCHAR(50)  | Standardized gender value (Male, Female, n/a). |
| birthdate     | DATE         | Customer date of birth (YYYY-MM-DD). |
| create_date   | TIMESTAMP    | Timestamp when the record was created in the warehouse. |

---

## 2. gold.dim_products

**Purpose:**  
Stores product attributes and hierarchical classification details.

**Primary Key:** `product_key` (Surrogate Key)

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product record. |
| product_id | INT | Business key identifying the product from the source system. |
| product_number | VARCHAR(50) | Structured alphanumeric product code. |
| product_name | VARCHAR(100) | Descriptive product name. |
| category_id | VARCHAR(50) | Identifier representing the product category. |
| category | VARCHAR(50) | High-level product classification (e.g., Bikes, Components). |
| subcategory | VARCHAR(50) | Detailed product classification within a category. |
| maintenance_required | VARCHAR(10) | Indicates whether maintenance is required (Yes/No). |
| cost | INT | Base cost of the product. |
| product_line | VARCHAR(50) | Product line classification (Road, Mountain, Touring, etc.). |
| start_date | DATE | Date when the product became active. |
| end_date | DATE | Date when the product was discontinued (if applicable). |

---

## 3. gold.fact_sales

**Purpose:**  
Stores transactional sales data for performance and revenue analysis.

**Grain:**  
One row per sales order line item.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | VARCHAR(50) | Unique identifier for each sales order. |
| product_key | INT | Foreign key referencing gold.dim_products. |
| customer_key | INT | Foreign key referencing gold.dim_customers. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped. |
| due_date | DATE | Date when payment was due. |
| sales_amount | INT | Total revenue for the order line. |
| quantity | INT | Number of units sold. |
| price | INT | Unit price of the product. |
