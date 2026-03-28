-- Analytics Layer Views
-- These views are built on top of the Gold layer to support BI and reporting

-- Sales Summary
create view v_sales_summary as
select 
date_trunc('month', order_date) as month,
sum(sales_amount ) as revenue,
sum(quantity ) as total_units,
count(distinct order_number ) as total_orders
from gold.fact_sales 
group by date_trunc('month', order_date) 

-- Product Performance
create view v_product_performance as
select 
p.product_key ,
p.product_name ,
p.category ,
sum(f.sales_amount ) as revenue,
sum(f.quantity ) as units_sold
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key 
group by p.product_key , p.product_name , p.category 

-- Customer Insights
create view v_customer_insights as
select
c.customer_key ,
c.first_name ,
sum(f.sales_amount ) as total_spent,
count(distinct f.order_number ) as total_orders
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key 
group by c.customer_key , c.first_name 


-- Repeat Customers
create view v_repeat_customers as 
select
customer_key ,
count(distinct order_number ) as total_orders
from gold.fact_sales
group by customer_key
having count(order_number ) > 1

-- Customer Segmentation (Basic Spend Buckets)
create view v_customer_segmentation as
select
customer_key ,
sum(sales_amount ) as total_spent,
case
	when sum(sales_amount ) > 50000 then 'High Value'
	when sum(sales_amount ) > 20000 then 'Medium Value'
	else 'Low Value'
end as segment
from gold.fact_sales 
group by customer_key 
