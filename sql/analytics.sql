-- Business Questions --

-- Q1 -> Total revenue over time (monthly)
select
    date_trunc('month', order_date) as month,
    sum(sales_amount) as revenue
from gold.fact_sales 
group by date_trunc('month', order_date)
order by month;

-- Q2 - > Top performing products (by revenue)
select 
  p.product_name ,
  sum(f.sales_amount) as revenue 
from gold.fact_sales f
left join gold.dim_products p
  on f.product_key = p.product_key 
group by p.product_name 
order by revenue desc
limit 10

-- Q3 -> Top performing categories (by revenue)
select
  p.product_name ,
  sum(s.sales_amount ) as revenue,
  rank() over (order by sum(s.sales_amount ) desc) as rank
from gold.fact_sales s
left join gold.dim_products p
  on s.product_key = p.product_key 
group by p.product_name 

-- Q4 -> Top customers
select 
  c.customer_id ,
  c.first_name ,
  sum(f.sales_amount ) as total_spent
from gold.fact_sales f
left join gold.dim_customers c
  on f.customer_key = c.customer_key 
group by c.customer_id, c.first_name  
order by total_spent desc
limit 10

-- Q5 -> Repeat Customers
select
  customer_key ,
  count(distinct order_number ) as total_orders
from gold.fact_sales
group by customer_key
having count(order_number ) > 1

-- Q6 -> Customer Segmentation (Basic Spend Buckets)
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

-- Q7 -> Average Order Value (AOV)
select 
  sum(sales_amount ) / count(distinct order_number ) as avg_order_value
from gold.fact_sales 
