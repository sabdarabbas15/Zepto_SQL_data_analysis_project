create table zepto(sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),discountPercent NUMERIC(5,2),
availableQuantity INTEGER,discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,outOfStock BOOLEAN,quantity INTEGER
);
--data exploration

--count of rows
select count(*) from zepto

--sample data
select * from zepto limit 10;
--null values
SELECT*FROM zepto 
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null;

--different product categories
SELECT DISTINCT category FROM zepto ORDER BY category

--products in stock vs out stock
SELECT outofstock,count(sku_id) FROM zepto GROUP BY outofstock

--product names present multiple times
SELECT name,count(sku_id) as "number of skus" FROM zepto
GROUP BY name HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--data cleaning

--product with price
SELECT*FROM zepto WHERE mrp = 0 OR discountedsellingprice = 0;

--deleting row
DELETE FROM zepto WHERE mrp = 0

--convert paisa to rupees
UPDATE zepto SET mrp=mrp/100.0,discountedsellingprice = discountedsellingprice/100.0
--CHECKING
SELECT mrp,discountedsellingprice FROM zepto

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name,mrp,discountpercent FROM zepto
ORDER BY discountpercent DESC LIMIT 10

--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name,mrp FROM zepto
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC

--Q3.Calculate Estimated Revenue for each category
SELECT category,sum(discountedsellingprice * availablequantity) AS total_revenue FROM zepto
GROUP BY category
ORDER BY total_revenue

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountpercent FROM zepto 
WHERE mrp > 500 AND discountpercent <10 
ORDER BY mrp DESC,discountpercent DESC

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,ROUND(AVG(discountpercent),2) AS avg_discount FROM zepto
GROUP BY category
ORDER BY avg_discount DESC LIMIT 5

-- Q6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name,weightingms,discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) AS price_pergram FROM zepto
WHERE weightingms >= 100
ORDER BY price_pergram

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name , weightingms,
CASE WHEN weightingms <1000 THEN 'low'
WHEN weightingms <5000 THEN 'high'
ELSE 'bulk'
END AS weight_category
FROM zepto

--Q8.What is the Total Inventory Weight Per Category 
SELECT category ,sum(weightingms * availablequantity) AS total_weight FROM zepto
GROUP BY category
ORDER BY total_weight