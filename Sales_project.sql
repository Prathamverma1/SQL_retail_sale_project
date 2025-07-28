CREATE TABLE retail_sale(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT 

);

-- DATA CLEANING
SELECT * FROM retail_sale
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
	
DELETE FROM retail_sale
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- DATA EXPLORATION
-- How many sales do we have?
SELECT count(*) as total_sale from retail_sale

-- How many distint customers do we have?
SELECT count(DISTINCT customer_id) from retail_sale

-- Categories in the data
SELECT DISTINCT category from retail_sale

-- DATA ANALYSIS -Solving business problems 

--Q.1. Write a SQL query to show the sales done on 05-11-2022
SELECT * FROM retail_sale
WHERE sale_date = '2022-11-05';

--Q.2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of November 2022
SELECT 
	*
FROM retail_sale
WHERE
	category = 'Clothing'
	AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND quantiy > 3;

--Q.3. Write SQL query to calculate the total sales for each category
SELECT
	category,
	SUM (total_sale) as net_sale,
	COUNT(transactions_id) as total_orders
FROM retail_sale
GROUP BY category


--Q.4. Write the SQL query to find the average age of customers who purchased from beauty category.
SELECT ROUND(AVG(age),2) From retail_sale
WHERE category = 'Beauty'

--Q.5. Write the SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sale
WHERE total_sale > 1000


--Q.6. Write the SQL Query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(transactions_id)
FROM retail_sale
GROUP BY category, gender

--Q.7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM (
	SELECT
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sale
	GROUP BY year, month
) as t1
WHERE rank = 1

--Q.8. Write the SQL query to find the top 5 customers based on highest total sale
SELECT
	customer_id,
	SUM(total_sale) as total_sale
FROM retail_sale
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5

--Q.9. Write the SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sale
GROUP BY category

--Q.10 Write the SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)

WITH hourly_sales as (
	SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
	FROM retail_sale
 )
 SELECT shift, COUNT(transactions_id)
 FROM hourly_sales
 GROUP BY shift
ORDER BY 2 DESC