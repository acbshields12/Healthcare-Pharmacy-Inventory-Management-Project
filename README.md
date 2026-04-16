🏥 Pharmacy Inventory & Sales Analytics Dashboard
📌 Overview

This project analyzes pharmacy inventory and sales data to generate actionable insights using MySQL and Power BI. It focuses on tracking revenue performance, monitoring stock levels, and identifying risks such as low inventory and expiring medications.

🎯 Objectives
Evaluate overall sales and revenue performance
Monitor inventory levels and stock availability
Identify medications at risk of stockout or expiration
Build an interactive dashboard for data-driven decision-making
🛠️ Tools & Technologies
MySQL – Data extraction, joins, and aggregations
Power BI – Data modeling, DAX calculations, and dashboard design
Excel – Data preparation and cleaning
🗄️ Dataset Structure
📦 meds_data
medication_id
medication_name
category
stock_quantity
reorder_level
unit_price
expiry_date
💊 sales_data
sale_id
medication_id
quantity_sold
sale_date
📊 Key Performance Indicators (KPIs)
💰 Total Revenue
📦 Total Quantity Sold
🧮 Inventory Value
⚠️ Low Stock Count
🚨 Out of Stock
⏳ Expiring Soon
📊 Average Revenue per Medication
🥇 Top Selling Medication
💰 Sample SQL Query
SELECT 
    SUM(s.quantity_sold * m.unit_price) AS total_revenue
FROM sales_data s
JOIN meds_data m
    ON s.medication_id = m.medication_id;
📈 Power BI Dashboard Features
KPI cards for quick performance overview
Monthly revenue trend (line chart)
Top-selling medications (bar chart)
Revenue distribution by category (donut chart)
Stock vs reorder level comparison
Low stock and out-of-stock monitoring
Expiry tracking by month
Interactive slicers (category, medication, date)
🧠 Key Insights
A small group of medications drives the majority of total revenue
Several medications frequently fall below reorder levels, indicating supply risk
Some inventory is nearing expiration, increasing the risk of wastage
⚠️ Data Validation & Issue Resolution

A discrepancy was identified between SQL and Power BI revenue calculations:

MySQL: 30,614
Power BI: 28,068
🔍 Root Cause

Missing or unmatched medication_id values between tables caused RELATED() in Power BI to return blanks, resulting in lower revenue.

✅ Resolution
Verified and corrected table relationships (Many-to-One)
Identified unmatched records
Adjusted DAX calculations to handle missing values
Ensured consistency between SQL and Power BI logic
📌 Key Skills Demonstrated
SQL joins and aggregations
Data modeling in Power BI
DAX measures (SUMX, RELATED, CALCULATE)
Dashboard design and data visualization
Data validation and debugging
📸 Dashboard Preview

Add your Power BI dashboard screenshot here

🚀 Future Improvements
Add demand forecasting for inventory planning
Implement automated data refresh
Enhance dashboard with drill-through and tooltips
👤 Author

Adriane Clark Ballesteros
Aspiring Healthcare Data Analyst
