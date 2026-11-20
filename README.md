# Retail Sales Analytics Project | SQL & Power BI

## Project Overview

This project focuses on analysing retail sales data to understand business performance, product sales, customer behaviour, and monthly revenue trends.

PostgreSQL is used for database management, SQL is used to perform data analysis, and Power BI is used to develop an interactive four-page dashboard.

The project demonstrates an end-to-end data analytics workflow, from database creation and data validation to business analysis and dashboard development.

## Business Problem

The business wants to understand its sales performance and identify opportunities for improvement.

The analysis focuses on:

- Overall sales and revenue performance
- Monthly revenue trends
- Best-performing products
- Revenue contribution by category
- Customer purchasing performance
- Sales contribution by city

## Project Objectives

- Create and manage a PostgreSQL database.
- Analyse retail sales data using SQL.
- Identify revenue trends and sales patterns.
- Evaluate product and category performance.
- Analyse customer purchasing behaviour.
- Develop an interactive Power BI dashboard.
- Generate business insights and recommendations.

## Tools & Technologies

- PostgreSQL
- SQL
- Power BI Desktop
- DAX
- Git & GitHub

## Database Structure

The project uses a relational database containing information about:

- Customers
- Products
- Orders
- Order Items
- Returns

## SQL Analysis

SQL queries were written to answer business-related questions and analyse retail performance.

### Analysis Areas

**1. Sales Analysis**
- Total revenue
- Total orders
- Monthly revenue
- Overall sales performance

**2. Product Analysis**
- Revenue by product
- Units sold
- Category-wise revenue
- Top-performing products

**3. Customer Analysis**
- Top 10 customers by revenue
- Customer revenue contribution
- Customer purchasing performance
- Sales by city

**4. Data Validation**
- Checking duplicate records
- Validating table relationships
- Identifying unmatched records

### SQL Concepts Used

- SELECT, WHERE, ORDER BY
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- Aggregate Functions
- CASE WHEN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- Date Functions

## Power BI Dashboard

An interactive four-page dashboard was developed using Power BI to visualise retail sales performance.

### 1. Sales Overview

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Monthly Revenue
- Category Performance

### 2. Product Review Analysis

- Product-wise Revenue
- Units Sold
- Category Performance
- Product Comparisons

### 3. Customer Overview

- Customer Revenue
- Top Customers
- City-wise Sales
- Customer Performance

### 4. Sales Trends

- Monthly Revenue Trends
- Monthly Order Trends
- Sales Performance Over Time
- Revenue Patterns

## Power BI Features

- Interactive KPI Cards
- DAX Measures
- Data Modelling
- Charts and Visualisations
- Interactive Slicers
- Dashboard Filtering

## Project Workflow

1. Created a PostgreSQL database.
2. Created and organised database tables.
3. Imported and validated retail sales data.
4. Established relationships between tables.
5. Wrote SQL queries to answer business questions.
6. Analysed sales, products, customers and revenue.
7. Connected PostgreSQL to Power BI.
8. Created DAX measures and dashboard visuals.
9. Developed an interactive four-page dashboard.
10. Analysed the results and identified business insights.

## Key Business Insights

Insights identified from the SQL analysis and Power BI dashboard:

- Highest revenue-generating product category.
- Top-performing product based on revenue.
- Highest-value customers.
- City-wise sales performance.
- Monthly revenue trends.

## Business Recommendations

- Focus on high-performing product categories.
- Optimise inventory based on product sales performance.
- Develop customer retention strategies.
- Identify opportunities in cities with lower sales.
- Monitor monthly revenue trends for better sales planning.

## Dashboard Screenshots

### Sales Overview
![Sales Overview](<Sales Overview.png>)

### Product Review Analysis
![Product Review Analysis](<Product Review Analysis.png>)

### Customer Overview
![Customer Overview](<Customer Overview.png>)

### Sales Trends
![Sales Trends](<Sales Trends.png>)

## Project Folder Structure

```text
retail sales analysis project/
│
├── Documentation/
│   ├── business_questions.md
│   └── insights_and_recommendations.md
├── POWER BI/
│   └── retail sales analytics.pbix
├── Screenshots/
│   ├── Customer Overview.png
│   ├── Product Review Analysis.png
│   ├── Sales Overview.png
│   └── Sales Trends.png
├── SQL/
│   ├── business_questions.sql
│   ├── create_tables.sql
│   └── data_analysis_queries.sql
│
├── Readme.md
└── retail sales analytics.pdf
```

## Conclusion

This project demonstrates practical skills in PostgreSQL, SQL, data analysis, Power BI, DAX, data visualisation and business intelligence.

It showcases how retail data can be organised, analysed and transformed into meaningful insights through SQL queries and interactive dashboards.