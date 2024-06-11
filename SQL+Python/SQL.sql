create table df_orders(
order_id int primary key,
order_date date,
ship_mode varchar(20),
segment varchar(20),
country varchar(20),
city varchar(20),
state varchar(20),
postal_code varchar(20),
region varchar(20),
category varchar(20),
sub_category varchar(20),
product_id varchar(20),
quantity int,
discount decimal(7,2),
sale_price decimal(7,2),
profit decimal(7,2)
)

--select * from df_orders

--top 10 highest revenue generating products
select top 10 product_id,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc

--top 5 highest selling product in each region

select * from (
select region,product_id,
sum(quantity) as qt,
rank() over (partition by region order by sum(quantity) desc) as rank
from df_orders
group by product_id,region)A
where rank<=5
order by rank asc

--find month over month growth for 2022 and 2023
with cte as (
select year(order_date) as order_year,MONTH(order_date) as order_month ,sum(sale_price) as sales
from df_orders
group by  year(order_date),MONTH(order_date)
)select order_month,
sum(case when order_year=2022 then sales else 0 end) as '2022',
sum(case when order_year=2023 then sales else 0 end) as '2023_'
from cte
group by order_month


--For each category which month had highest sales 
with cte as(
select format(order_date,'yyyyMM') as year_month,category as category ,sum(sale_price) as sales
from df_orders
group by format(order_date,'yyyyMM'),category
 )select * from(
 select *,
 rank() over (partition by category order by sales desc) as rank
  from cte
 )A where rank=1


 

 with cte as (
select sub_category,year(order_date) as order_year,MONTH(order_date) as order_month ,sum(sale_price) as sales
from df_orders
group by  sub_category,year(order_date),MONTH(order_date)
),cte2 as(
select sub_category,
sum(case when order_year=2022 then sales else 0 end) as 'sales_2022',
sum(case when order_year=2023 then sales else 0 end) as 'sales_2023'
from cte
group by sub_category
)select top 1 *, (sales_2023-sales_2022) as growth
from cte2
order by growth desc
