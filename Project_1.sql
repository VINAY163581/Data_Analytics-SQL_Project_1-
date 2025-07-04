CREATE DATABASE sql_project_1;


-- Create TABLE

USE sql_project_1;

CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,	
    sale_date DATE,	 
    sale_time TIME,	
    customer_id	INT,
    gender	VARCHAR(15),
    age	INT,
    category VARCHAR(15),	
    quantity	INT,
    price_per_unit FLOAT,	
    cogs	FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales;



SELECT COUNT(*) FROM retail_sales

SELECT * FROM retail_sales WHERE transaction_id IS NULL;

SELECT * FROM retail_sales WHERE sale_date IS NULL;

SELECT * FROM retail_sales WHERE transaction_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


-- Data Exploration

-- How many sales we have?

SELECT COUNT(*) as total_sale FROM retail_sales

-- How many customers we have?

SELECT COUNT(customer_id) as total_sale FROM retail_sales

-- How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- How many category we have?

SELECT category FROM retail_sales

-- How many unique category we have?

SELECT DISTINCT category FROM retail_sales

-- Data Analysis and Business Key Problems

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is greater than or equal to 4 in the month of Nov-2022

SELECT * FROM retail_sales WHERE category = 'Clothing' AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' AND quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) as net_sale FROM retail_sales GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT AVG(age) as avg_age FROM retail_sales WHERE category = 'Beauty';

SELECT ROUND(AVG(age)) as avg_age FROM retail_sales WHERE category = 'Beauty';

SELECT ROUND(AVG(age), 1) as avg_age FROM retail_sales WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, COUNT(*) as total_trans FROM retail_sales GROUP BY category, gender;

SELECT category, gender, COUNT(*) as total_trans FROM retail_sales GROUP BY category, gender ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT EXTRACT(YEAR FROM sale_date) as year, EXTRACT(MONTH FROM sale_date) as month, AVG(total_sale) as avg_sale FROM retail_sales GROUP BY 1, 2;

SELECT EXTRACT(YEAR FROM sale_date) as year, EXTRACT(MONTH FROM sale_date) as month, AVG(total_sale) as avg_sale FROM retail_sales GROUP BY 1, 2 ORDER BY 1, 2;

SELECT * FROM 
(
  SELECT EXTRACT(YEAR FROM sale_date) as year, EXTRACT(MONTH FROM sale_date) as month, AVG(total_sale) as avg_sale, 
   RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank_1 FROM retail_sales GROUP BY 1, 2
) as t1

WHERE rank_1 = 1;



SELECT year, month, avg_sale
FROM 
(
  SELECT EXTRACT(YEAR FROM sale_date) as year, EXTRACT(MONTH FROM sale_date) as month, AVG(total_sale) as avg_sale, 
   RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank_1 FROM retail_sales GROUP BY 1, 2
) as t1

WHERE rank_1 = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, SUM(total_sale) as total_sale FROM retail_sales GROUP BY 1 ORDER BY 2 DESC;

SELECT customer_id, SUM(total_sale) as total_sale FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT customer_id) FROM retail_sales GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


SELECT *, CASE 
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
               END as shift FROM retail_sales;
               
WITH hourly_sales
AS 
(
SELECT *, CASE 
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
               END as shift FROM retail_sales
               
             )
SELECT shift, COUNT(*) as total_orders FROM hourly_sales GROUP BY shift;




