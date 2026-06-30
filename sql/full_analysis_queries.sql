CREATE DATABASE customer_churn;

USE customer_churn;
SHOW TABLES;
CREATE TABLE customer_data (
    customerID VARCHAR(25),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(5)
);
SELECT COUNT(*) FROM customer_data;

#Section 1 - Basic Analysis

-- Total Customers

SELECT COUNT(*) AS Total_Customers
FROM customer_churn_cleaned;


-- Total Churned Customers

SELECT COUNT(*) AS Churned_Customers
FROM customer_churn_cleaned
WHERE Churn='Yes';


-- Active Customers

SELECT COUNT(*) AS Active_Customers
FROM customer_churn_cleaned
WHERE Churn='No';


-- Overall Churn Rate

SELECT
ROUND(
COUNT(CASE WHEN Churn='Yes' THEN 1 END)*100.0/
COUNT(*),2
) AS Churn_Rate
FROM customer_churn_cleaned;

#Section 2 - Customer Demographics

-- Gender Distribution

SELECT
Gender,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY Gender;


-- Senior Citizen Distribution

SELECT
SeniorCitizen,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY SeniorCitizen;


-- Partner Distribution

SELECT
Partner,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY Partner;


-- Dependents Distribution

SELECT
Dependents,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY Dependents;

#Section 3 - Service Analysis

-- Internet Service

SELECT
InternetService,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY InternetService;


-- Phone Service

SELECT
PhoneService,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY PhoneService;


-- Contract Type

SELECT
Contract,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY Contract;


-- Payment Method

SELECT
PaymentMethod,
COUNT(*) AS Customers
FROM customer_churn_cleaned
GROUP BY PaymentMethod;

#Section 4 - Churn Analysis

-- Churn by Gender

SELECT
Gender,
COUNT(*) AS Churned
FROM customer_churn_cleaned
WHERE Churn='Yes'
GROUP BY Gender;


-- Churn by Contract

SELECT
Contract,
COUNT(*) AS Churned
FROM customer_churn_cleaned
WHERE Churn='Yes'
GROUP BY Contract;


-- Churn by Payment Method

SELECT
PaymentMethod,
COUNT(*) AS Churned
FROM customer_churn_cleaned
WHERE Churn='Yes'
GROUP BY PaymentMethod;


-- Churn by Internet Service

SELECT
InternetService,
COUNT(*) AS Churned
FROM customer_churn_cleaned
WHERE Churn='Yes'
GROUP BY InternetService;

#Section 5 - Revenue Analysis

-- Average Monthly Charges

SELECT
ROUND(AVG(MonthlyCharges),2)
FROM customer_churn_cleaned;


-- Average Total Charges

SELECT
ROUND(AVG(TotalCharges),2)
FROM customer_churn_cleaned;


-- Revenue by Contract

SELECT
Contract,
ROUND(SUM(TotalCharges),2) AS Revenue
FROM customer_churn_cleaned
GROUP BY Contract;

#Advanced SQL Analysis

-- Customer Spending Category (CASE)
SELECT
    CustomerID,
    MonthlyCharges,
    CASE
        WHEN MonthlyCharges < 35 THEN 'Low'
        WHEN MonthlyCharges BETWEEN 35 AND 70 THEN 'Medium'
        ELSE 'High'
    END AS Spending_Category
FROM customer_churn_cleaned;

-- Customer Loyalty Category (CASE)
SELECT
    CustomerID,
    Tenure,
    CASE
        WHEN Tenure < 12 THEN 'New Customer'
        WHEN Tenure BETWEEN 12 AND 36 THEN 'Regular Customer'
        ELSE 'Loyal Customer'
    END AS Customer_Category
FROM customer_churn_cleaned;

#Contract Types with Average Monthly Charges Greater Than 60 (HAVING)
SELECT
    Contract,
    ROUND(AVG(MonthlyCharges),2) AS Avg_Monthly_Charges
FROM customer_churn_cleaned
GROUP BY Contract
HAVING AVG(MonthlyCharges) > 60;

#Payment Methods Used by More Than 1,000 Customers
SELECT
    PaymentMethod,
    COUNT(*) AS Total_Customers
FROM customer_churn_cleaned
GROUP BY PaymentMethod
HAVING COUNT(*) > 1000;

#Rank Customers by Monthly Charges
SELECT
    CustomerID,
    MonthlyCharges,
    RANK() OVER (ORDER BY MonthlyCharges DESC) AS Customer_Rank
FROM customer_churn_cleaned;

#Dense Rank Customers
SELECT
    CustomerID,
    MonthlyCharges,
    DENSE_RANK() OVER (ORDER BY MonthlyCharges DESC) AS Customer_Dense_Rank
FROM customer_churn_cleaned;

#Top 10 Highest Paying Customers
SELECT
    CustomerID,
    MonthlyCharges,
    TotalCharges
FROM customer_churn_cleaned
ORDER BY TotalCharges DESC
LIMIT 10;

#Top 10 Longest Tenure Customers
SELECT
    CustomerID,
    Tenure,
    TotalCharges
FROM customer_churn_cleaned
ORDER BY Tenure DESC
LIMIT 10;

#Churned Customers (CTE)
WITH Churn_Customers AS
(
    SELECT *
    FROM customer_churn_cleaned
    WHERE Churn = 'Yes'
)

SELECT
    Contract,
    COUNT(*) AS Churned_Customers
FROM Churn_Customers
GROUP BY Contract;

#Loyal Customers (CTE)
WITH Loyal_Customers AS
(
    SELECT *
    FROM customer_churn_cleaned
    WHERE Tenure >= 60
)

SELECT
    ROUND(AVG(MonthlyCharges),2) AS Avg_Monthly_Charges,
    ROUND(AVG(TotalCharges),2) AS Avg_Total_Charges
FROM Loyal_Customers;

#Churn Rate by Contract
SELECT
    Contract,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM customer_churn_cleaned
GROUP BY Contract
ORDER BY Churn_Rate DESC;

#Churn Rate by Payment Method
SELECT
    PaymentMethod,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM customer_churn_cleaned
GROUP BY PaymentMethod
ORDER BY Churn_Rate DESC;

#Churn Rate by Internet Service
SELECT
    InternetService,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM customer_churn_cleaned
GROUP BY InternetService
ORDER BY Churn_Rate DESC;

#Top 5 Customer Segments by Revenue
SELECT
    Contract,
    ROUND(SUM(TotalCharges),2) AS Total_Revenue
FROM customer_churn_cleaned
GROUP BY Contract
ORDER BY Total_Revenue DESC
LIMIT 5;
