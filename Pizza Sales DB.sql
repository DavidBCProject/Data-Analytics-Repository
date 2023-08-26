
/*KPI*/

--A. KPI’s

SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales

SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS Average_Order_Value
FROM pizza_sales

SELECT SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales

SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales

SELECT CAST((SUM(quantity)*1.00)/COUNT(DISTINCT order_id) AS decimal(10,2)) AS Average_Pizza_Per_Order
FROM pizza_sales

/*CHART REQUIREMENT*/

--B. Daily Trend for Total Orders

SELECT DATENAME(DW,order_date) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY DATENAME(DW,order_date)

--C. Monthly Trend for Orders

SELECT DATENAME(MONTH,order_date) AS Month_name, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY DATENAME(MONTH,order_date)

--D. % of Sales by Pizza Category

SELECT pizza_category, CAST(SUM(total_price) AS decimal(10,2)) AS Total_Sales, CAST(SUM(total_price)*100.00/(SELECT SUM(total_price) FROM pizza_sales) AS decimal(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

SELECT pizza_category, CAST(SUM(total_price) AS decimal(10,2)) AS Total_Sales, CAST(SUM(total_price)*100.00/(SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) AS decimal(10,2)) AS PCT
FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category

--E. % of Sales by Pizza Size

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue, CAST(SUM(total_price)*100.00/(SELECT SUM(total_price) FROM pizza_sales) AS decimal(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size

--F. Total Pizzas Sold by Pizza Category

SELECT pizza_category, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

SELECT pizza_category, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

--G. Top 5 Pizzas by Revenue

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(total_price) DESC

--H. Bottom 5 Pizzas by Revenue

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(total_price) ASC

SELECT *
FROM pizza_sales