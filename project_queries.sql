-- Customer Retention & Transaction Behavior Analysis

-- Disable safe updates
SET SQL_SAFE_UPDATES = 0;

-- Remove NULL customers
DELETE FROM online_retail_ii
WHERE `Customer ID` IS NULL;

-- Remove returns
DELETE FROM online_retail_ii
WHERE Quantity <= 0;

-- Add Revenue column
ALTER TABLE online_retail_ii
ADD COLUMN Revenue DECIMAL(10,2);

-- Update Revenue
UPDATE online_retail_ii
SET Revenue = Quantity * Price;

-- Total Revenue
SELECT SUM(Revenue) AS Total_Revenue
FROM online_retail_ii;

-- Total Unique Customers
SELECT COUNT(DISTINCT `Customer ID`) AS Total_Customers
FROM online_retail_ii;

-- Repeat vs One-Time Customers
SELECT 
    CASE 
        WHEN transaction_count = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS Customer_Type,
    COUNT(*) AS Number_of_Customers
FROM (
    SELECT `Customer ID`, COUNT(DISTINCT Invoice) AS transaction_count
    FROM online_retail_ii
    GROUP BY `Customer ID`
) AS customer_transactions
GROUP BY Customer_Type;

-- Retention Rate
SELECT 
    ROUND(
        SUM(CASE WHEN transaction_count > 1 THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 
        2
    ) AS Retention_Rate_Percentage
FROM (
    SELECT `Customer ID`, COUNT(DISTINCT Invoice) AS transaction_count
    FROM online_retail_ii
    GROUP BY `Customer ID`
) AS customer_transactions;

-- Top 10 Customers
SELECT `Customer ID`,
       SUM(Revenue) AS Total_Spent
FROM online_retail_ii
GROUP BY `Customer ID`
ORDER BY Total_Spent DESC
LIMIT 10;
