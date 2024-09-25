# Global Electronics Retailer Analysis

## Overview
This project provides data-driven insights into the sales performance of a global electronics company. It begins by using MySQL to generate general sales data by month, analyze sales by order type, and calculate the time gap between order date and delivery date, offering a deeper understanding of the company’s supply chain efficiency. Additionally, an analysis based on store performance reveals store size and profit margins, helping the company develop future pricing strategies. The data is then integrated into Power BI for a comprehensive trend analysis. Notably, 2019 stands out with the highest sales over the last five years. Furthermore, a cohort analysis of customer retention and product characteristics in 2019 provides deeper insights into customer behavior and product preferences.

## Project Goals
Using SQL to answer the questions
* The revenue, profit of top 10 of product over years
* The revenue of top 10 product category over time

<img width="345" alt="Screenshot 2024-09-25 at 17 46 43" src="https://github.com/user-attachments/assets/36cc4bc4-044d-4660-b1e0-67947995ed2d">

* Are there any seasonal patterns or trends for average order volume or revenue?

<img width="289" alt="Screenshot 2024-09-25 at 17 47 42" src="https://github.com/user-attachments/assets/3b94ac14-344a-4cc2-8805-22a15cc12e51">

* How long is the average delivery time in days? Has that changed over time?

<img width="415" alt="Screenshot 2024-09-25 at 17 48 36" src="https://github.com/user-attachments/assets/38ddd63c-11d1-498e-836f-f8e0e101ad86">

* How can you create a report that displays each store's performance across different product categories Profitable rate

<img width="285" alt="Screenshot 2024-09-25 at 17 48 55" src="https://github.com/user-attachments/assets/b21861ee-78b8-4a64-89d3-8e4a31fbe828">


## Dashboard Overview
Using Exported dataset from SQL task and 2019 Sales_data to answer questions:
![Screenshot 2024-09-25 172505](https://github.com/user-attachments/assets/e201d14c-dcfb-4c4f-9a25-57b6ed055bed)
* The US emerged as the highest sales market for the electronics retailer in 2019, generating nearly $8M in revenue. Following that, online sales reached $3.9M, with other countries contributing additional sales throughout the year. Remarkably, sales and profit were notably low in April 2019 across all regions, with the US hitting a low point at just $0.05M. However, both sales and profit showed a gradual increase, peaking towards the end of the year.
![Screenshot 2024-09-25 192355](https://github.com/user-attachments/assets/6a57c82d-353d-4bd8-95b4-5fdeb958913f)
Monthly Cohort Analysis - Total Revenue (Top)
* The February 2019 cohort is the highest revenue-generating cohort, contributing $1.95M in its first month, with steady declines in subsequent months, but significant spikes in the 9th and 12th months. Customer engagement typically wanes after 3-4 months, with revenues declining significantly, indicating a need to boost retention and possibly remarketing strategies.
* Consistent revenues across months could highlight periods of effective marketing or product launches.

Customer Retention by Months Distribution
* With retention rate: 76.32% of customers are retained in the first month, after which the retention drops sharply. By the 3rd month, only about 3.6% of customers are still active, and it further decreases in subsequent months.

Quantity of Product Per Order Histogram (Bottom-Left)
* Bigger orders (obrt 5 items) have significantly fewer occurrences (around 0.3K-0.6K), indicating that customers tend to buy one or some products per order. To solve this problem, the company can start some promotion to increase number items per order in future.
![Screenshot 2024-09-25 192331](https://github.com/user-attachments/assets/e24c15e7-364d-458e-b5e0-413d5dce8b52)
* Top 10 Products with Highest Sales and Profit: Highlights the top-selling products and their associated profits.
* Computers stand out as the top category, generating $7M in sales and $4.1M in profits, indicating it’s the largest revenue and profit driver. Home Appliances rank second with $2.7M in profits from $1.6M in sales, showing a strong profit margin. Cameras and Camcorders, Cell Phones, and TV & Video each generate over $1M in sales and profits, highlighting these categories as important contributors.
Black products dominate, accounting for 32.54% of sales with a total of $4.78M.
