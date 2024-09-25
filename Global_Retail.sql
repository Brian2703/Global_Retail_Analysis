Use BALA_Project;

SELECT * FROM CUSTOMERS;
SELECT * FROM DATA_DICTIONARY;
SELECT * FROM EXCHANGE_RATES;
SELECT * FROM PRODUCTS;
SELECT * FROM SALES;
SELECT * FROM STORES;

-- The revenue, profit of top 10 of product over years
SELECT p.`Product Name`, 
CAST(SUM(s.Quantity*CAST(REPLACE(p.`Unit Price USD`,'$','') as float)*e.`Exchange`) AS DECIMAL(10,2)) AS Total_Sales,
CAST((SUM(s.Quantity*CAST(REPLACE(p.`Unit Price USD`,'$','') as float)*e.`Exchange`)
-SUM(s.Quantity*CAST(REPLACE(p.`Unit Cost USD`,'$','') as float)*e.`Exchange`)) AS DECIMAL(10,2)) AS Total_Profit
FROM PRODUCTS p
JOIN SALES s on s.ProductKey=p.ProductKey
JOIN EXCHANGE_RATES e on e.Currency=s.`Currency Code` AND e.`Date`=s.`Order Date`
GROUP BY p.`Product Name`  
ORDER BY Total_Profit DESC LIMIT 10;

-- The revenue of top 10 product category over time

WITH RankedSales AS (
    SELECT 
        p.Category, 
        CAST(SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) AS DECIMAL(10,2)) AS Total_Annual_Sales,
        YEAR(STR_TO_DATE(s.`Order Date`, '%m/%d/%Y')) AS Sales_Year,
        ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY YEAR(STR_TO_DATE(s.`Order Date`, '%m/%d/%Y')) ASC) AS RowNum
    FROM PRODUCTS p
    JOIN SALES s ON s.ProductKey = p.ProductKey
    JOIN EXCHANGE_RATES e ON e.Currency = s.`Currency Code` 
                         AND e.`Date` = s.`Order Date`
    GROUP BY p.Category, YEAR(STR_TO_DATE(s.`Order Date`, '%m/%d/%Y'))
)
SELECT 
    Category,
    Total_Annual_Sales,
    Sales_Year
FROM RankedSales
WHERE RowNum <= 10
ORDER BY Sales_Year ASC,Total_Annual_Sales DESC;

-- where are customers located, number of people - sales of country 
WITH Number_cus_per_State AS (
    SELECT c.`State Code` AS State,
           COUNT(*) AS TotalCustomers
    FROM CUSTOMERS c
    GROUP BY c.`State Code`
)
SELECT n.State,
       n.TotalCustomers,
       CAST(SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) AS DECIMAL(10,2)) AS Total_Sales,
       CAST((SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) 
             - SUM(s.Quantity * CAST(REPLACE(p.`Unit Cost USD`, '$', '') AS FLOAT) * e.`Exchange`)) AS DECIMAL(10,2)) AS Total_Profit
FROM Number_cus_per_State n
JOIN CUSTOMERS c ON c.`State Code` = n.State
JOIN SALES s ON s.CustomerKey = c.CustomerKey
JOIN PRODUCTS p ON s.ProductKey = p.ProductKey
JOIN EXCHANGE_RATES e ON e.Currency = s.`Currency Code` AND e.`Date` = s.`Order Date`
GROUP BY n.State, n.TotalCustomers
ORDER BY TotalCustomers DESC, Total_Sales DESC;

-- Are there any seasonal patterns or trends for average order volume or revenue?

WITH Order_Revenue AS (
    SELECT s.`Order Number` AS OrderID,
           SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) AS Revenue,
           MONTH(STR_TO_DATE(s.`Order Date`, '%m/%d/%Y')) AS MONTH_TIME,
           YEAR(STR_TO_DATE(s.`Order Date`, '%m/%d/%Y')) AS YEAR_TIME,
           CASE
               WHEN s.StoreKey = 0 THEN 'ONLINE ORDER'
               ELSE 'IN-STORE ORDER'
           END AS ORDER_TYPE
    FROM SALES s
    JOIN PRODUCTS p ON s.ProductKey = p.ProductKey
    JOIN EXCHANGE_RATES e ON e.Currency = s.`Currency Code` AND e.`Date` = s.`Order Date`
    GROUP BY s.`Order Number`, MONTH_TIME, YEAR_TIME, ORDER_TYPE
),
Order_Count AS (
    SELECT COUNT(*) AS TotalOrders, MONTH_TIME, YEAR_TIME, ORDER_TYPE
    FROM Order_Revenue
    GROUP BY MONTH_TIME, YEAR_TIME, ORDER_TYPE
)
SELECT 
    CAST(SUM(r.Revenue) AS DECIMAL(10,2)) AS Total_Revenue,
    COUNT(r.OrderID) AS TotalOrders,
    CAST(SUM(r.Revenue) / COUNT(r.OrderID) AS DECIMAL(10,2)) AS AOV,
    r.MONTH_TIME, r.YEAR_TIME, r.ORDER_TYPE
FROM Order_Revenue r
JOIN Order_Count c
ON r.MONTH_TIME = c.MONTH_TIME AND r.YEAR_TIME = c.YEAR_TIME AND r.ORDER_TYPE = c.ORDER_TYPE
GROUP BY r.MONTH_TIME, r.YEAR_TIME, r.ORDER_TYPE
ORDER BY r.YEAR_TIME ASC, r.MONTH_TIME ASC, r.ORDER_TYPE;

-- How long is the average delivery time in days? Has that changed over time?
SELECT 
    s.`Order Number`,
    s.`Order Date`,
    s.`Delivery Date`,
    DATEDIFF(STR_TO_DATE(s.`Delivery Date`, '%m/%d/%Y'), STR_TO_DATE(s.`Order Date`, '%m/%d/%Y')) AS Delivery_day,
    SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) AS Amount_Purchase
FROM SALES s 
JOIN PRODUCTS p ON s.ProductKey = p.ProductKey
JOIN EXCHANGE_RATES e ON e.Currency = s.`Currency Code` AND e.`Date` = s.`Order Date`
WHERE s.StoreKey = 0 GROUP BY Delivery_day, s.`Order Number`,s.`Order Date`,s.`Delivery Date`
ORDER BY s.`Order Number` ASC, Delivery_day ASC; 

/*How can you create a report that displays each store's performance across different product categories Profitable rate*/
SELECT 
    st.StoreKey, 
    CAST(SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) 
          - SUM(s.Quantity * CAST(REPLACE(p.`Unit Cost USD`, '$', '') AS FLOAT) * e.`Exchange`)) AS DECIMAL(10,2)) AS Total_Profit,
    (CAST((SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) 
          - SUM(s.Quantity * CAST(REPLACE(p.`Unit Cost USD`, '$', '') AS FLOAT) * e.`Exchange`)) AS DECIMAL(10,2))
     / CAST(SUM(s.Quantity * CAST(REPLACE(p.`Unit Price USD`, '$', '') AS FLOAT) * e.`Exchange`) AS DECIMAL(10,2))) AS Profitability_rate
FROM SALES s
JOIN STORES st ON st.StoreKey = s.StoreKey
JOIN PRODUCTS p ON s.ProductKey = p.ProductKey
JOIN EXCHANGE_RATES e ON e.Currency = s.`Currency Code` AND e.`Date` = s.`Order Date`
GROUP BY st.StoreKey;

-- Focus on the highest sales year - 2019
CREATE TABLE sales_2019 AS SELECT * FROM SALES WHERE `Order Date` LIKE '%2019%';

