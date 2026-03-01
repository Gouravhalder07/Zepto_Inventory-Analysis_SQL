drop table if exists zepto;

create table zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);

-- data exploration

-- count of rows
select count(*)from zepto;

-- sample data
select * from zepto limit 10;

-- null values
select * from zepto
where name IS NULL
OR
category IS NULL
OR 
mrp IS NULL
OR 
 discountPercent IS NULL
OR 
 discountedSellingPrice IS NULL
OR 
 weightInGms IS NULL
OR 
 availableQuantity IS NULL
OR 
 outOFStock IS NULL
OR 
 quantity IS NULL
;

-- different product categories
select distinct category 
from zepto
order by category;

select * from zepto limit 10;

-- product names present multiple times

select name, count(sku_id) as no_of_SKUs
from zepto
group by name
having count(sku_id)>1
order by no_of_SKUs desc;

-- data cleaning
-- product with price zero

select * from zepto
where mrp=0 or discountedSellingPrice=0

DELETE FROM zepto
WHERE mrp=0

-- convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

-- Q1. Find the top 10 best-value products based on the discount percentage.

select name,mrp, discountPercent
from zepto
order by discountPercent DESC
limit 10;

-- Q2. What are the products with high mrp but out of stock.

select distinct name, mrp,outOfStock
from zepto
where mrp>(select avg(mrp)from zepto)
and outOfStock = 'true'
order by mrp;

-- Q3. Calculate estimated Revenue for each category.

select category, 
sum(discountedSellingPrice*availableQUantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Q.4 Find all products where MRP is greater than 500 but discount is less than 10%.

select distinct name, mrp,discountpercent
from zepto
where mrp>500 and discountPercent<10.0
order by mrp desc,discountPercent desc ;

--Q.5. Identify the top 5 categories offering the highest average discount percentage.

select category,round(avg(discountPercent),2) as average_discount
from zepto
group by category
order by average_discount desc
limit 5;

-- Q.6. Find the price per gram from products above 100g and sort by values

select distinct name,
round(mrp/weightInGms,2) as price_per_grams
from zepto
where weightInGms>100
order by price_per_grams desc;

-- Q.7. Group the products into categories by weight into Low, Medium and Bulk

select distinct weightInGms 
from zepto
order by weightInGms desc;

select distinct name, weightInGms,
case when weightInGms < 1000 then 'Low'
	 when weightInGms < 5000 then 'Medium'
	 else 'Bulk'
	 end as weight_category
from zepto
order by weightInGms desc;

-- Q.8. What is total Inventory Weight per category

select category, sum(weightInGms*availableQuantity) as total_inventory_weight
from zepto
group by category
order by total_inventory_weight;
