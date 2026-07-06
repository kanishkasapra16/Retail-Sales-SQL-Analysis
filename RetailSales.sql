 -- retial anlsysis
 -- Day 1 – Database Design

 create database RetailSales;
 use RetailSales;
 
 -- table creation
 CREATE TABLE Sales (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(20),
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Product VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Salesperson VARCHAR(100)
);

SHOW TABLES;
describe Sales;

-- total records in table
SELECT * FROM Sales;
SELECT COUNT(*) AS Total_Records
FROM Sales;

SELECT COUNT(*) FROM mysql_project;
DROP TABLE sales;

-- renaming table from my sql to sales
RENAME TABLE mysql_project TO sales;

-- total rows in dataset
SELECT COUNT(*) FROM sales;

-- seeing the dataset
SELECT * FROM sales;
SHOW TABLES;

--  This query modifies the existing sales table by adding a primary key on the OrderID column. 
-- A primary key ensures that every order has a unique, non-NULL OrderID, which prevents duplicate records and allows each row to be uniquely identified.
-- It also improves data integrity and is commonly used when creating relationships with other tables.

SELECT COUNT(*) AS Total_Rows
FROM sales;

SHOW CREATE TABLE sales;

ALTER TABLE sales
ADD PRIMARY KEY(OrderID);


-- This query is used to find duplicate Order IDs in the sales table.
SELECT OrderID, COUNT(*) AS Total
FROM sales
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- delete data from table 
TRUNCATE TABLE sales;

SELECT COUNT(*) FROM sales;

ALTER TABLE sales
ADD PRIMARY KEY (OrderID);

SELECT COUNT(*) AS Total_Rows
FROM sales;

SELECT *
FROM sales
LIMIT 10;


SELECT OrderID, COUNT(*) AS Total
FROM sales
GROUP BY OrderID
HAVING COUNT(*) > 1;


--  day 2 - basic sql

-- Total Number of Orders
SELECT COUNT(*) AS Total_Orders
FROM sales;

--  total sales amount
SELECT ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales;

-- average order value
SELECT ROUND(AVG(Quantity * UnitPrice),2) AS Average_Order_Value
FROM sales;

-- maximum order amount
SELECT MAX(Quantity * UnitPrice) AS Maximum_Order_Amount
FROM sales;

-- minimum order amount
SELECT MIN(Quantity * UnitPrice) AS Minimum_Order_Amount
FROM sales;

-- number of customers
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM sales;

-- number of customers
SELECT COUNT(DISTINCT Product) AS Total_Products
FROM sales;

-- orders from delhi
SELECT *
FROM sales
WHERE City = 'Delhi';


-- orders after a given date
SELECT *
FROM sales
WHERE OrderDate > '2024-01-01';


-- electronics sales
SELECT *
FROM sales
WHERE Category = 'Electronics';


-- day 3 - aggreagtion

-- sales by city
SELECT City,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY City
ORDER BY Total_Sales DESC;

-- sales by category
SELECT Category,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY Category
ORDER BY Total_Sales DESC;

-- sales by salesperson
SELECT Salesperson,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC;


-- monthly sales
SELECT MONTH(OrderDate) AS Month,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY MONTH(OrderDate)
ORDER BY Month;

-- product wise sales
SELECT Product,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY Product
ORDER BY Total_Sales DESC;

-- top 5 cities sales
SELECT City,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 5;

-- bottom 5 cites
SELECT City,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY City
ORDER BY Total_Sales asc
LIMIT 5;

-- average quantity sold per product
SELECT Product,
       ROUND(AVG(Quantity),2) AS Average_Quantity
FROM sales
GROUP BY Product
ORDER BY Average_Quantity DESC;



-- day 4 - intermediate sql

-- top sellling product
SELECT Product,
       SUM(Quantity) AS Total_Quantity_Sold,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Quantity_Sold DESC
LIMIT 1;

-- least selling product
SELECT Product,
       SUM(Quantity) AS Total_Quantity_Sold,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Quantity_Sold ASC
LIMIT 1;

--  Customers with More Than 10 Purchases
SELECT CustomerID,
       CustomerName,
       COUNT(*) AS Total_Purchases
FROM sales
GROUP BY CustomerID, CustomerName
HAVING COUNT(*) > 10
ORDER BY Total_Purchases DESC;

-- Products Generating Above-Average Revenue (Subquery)
SELECT Product,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Product
HAVING SUM(Quantity * UnitPrice) >
(
    SELECT AVG(ProductRevenue)
    FROM
    (
        SELECT SUM(Quantity * UnitPrice) AS ProductRevenue
        FROM sales
        GROUP BY Product
    ) AS AvgRevenue
)
ORDER BY Total_Revenue DESC;

-- sales perfomance using case
SELECT OrderID,
       Product,
       Quantity,
       UnitPrice,
       Quantity * UnitPrice AS Revenue,
       CASE
           WHEN Quantity * UnitPrice >= 5000 THEN 'High Sales'
           WHEN Quantity * UnitPrice >= 2000 THEN 'Medium Sales'
           ELSE 'Low Sales'
       END AS Sales_Category
FROM sales;

-- city perfomance using case
SELECT City,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales,
       CASE
           WHEN SUM(Quantity * UnitPrice) >= 100000 THEN 'Excellent'
           WHEN SUM(Quantity * UnitPrice) >= 50000 THEN 'Good'
           ELSE 'Needs Improvement'
       END AS Performance
FROM sales
GROUP BY City
ORDER BY Total_Sales DESC;

-- category wise revenue
SELECT Category,
       ROUND(SUM(Quantity * UnitPrice),2) AS Revenue
FROM sales
GROUP BY Category
ORDER BY Revenue DESC;

--  Products Sold More Than Average Quantity (Subquery)
SELECT Product,
       SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY Product
HAVING SUM(Quantity) >
(
    SELECT AVG(ProductQuantity)
    FROM
    (
        SELECT SUM(Quantity) AS ProductQuantity
        FROM sales
        GROUP BY Product
    ) AS AvgQty
)
ORDER BY Total_Quantity DESC;

--  Top 5 Customers by Revenue
SELECT CustomerName,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY CustomerName
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Bottom 5 Customers
SELECT CustomerName,
       ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY CustomerName
ORDER BY Total_Revenue ASC
LIMIT 5;

-- Day 5 – Window Functions

-- rank salesperson by revenue
SELECT
    Salesperson,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue,
    RANK() OVER(ORDER BY SUM(Quantity * UnitPrice) DESC) AS Salesperson_Rank
FROM sales
GROUP BY Salesperson;

-- rank cities by revenue (dense rank)
SELECT
    City,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue,
    DENSE_RANK() OVER(ORDER BY SUM(Quantity * UnitPrice) DESC) AS City_Rank
FROM sales
GROUP BY City;

--  running total of sales( sum over)
SELECT
    OrderDate,
    ROUND(Quantity * UnitPrice,2) AS Sales_Amount,
    ROUND(
        SUM(Quantity * UnitPrice)
        OVER(ORDER BY OrderDate),
        2
    ) AS Running_Total
FROM sales;

-- previous days sales
SELECT
    OrderDate,
    ROUND(Quantity * UnitPrice,2) AS Today_Sales,
    LAG(Quantity * UnitPrice,1)
        OVER(ORDER BY OrderDate) AS Previous_Day_Sales
FROM sales;

-- next order date lead
SELECT
    OrderID,
    OrderDate,
    LEAD(OrderDate,1)
    OVER(ORDER BY OrderDate) AS Next_Order_Date
FROM sales;

--  Row Number for Every Order (ROW_NUMBER)
SELECT VERSION();


SHOW CREATE TABLE sales;
DESCRIBE sales;

SELECT @@sql_mode;

SELECT
    OrderID
FROM sales
LIMIT 5;

SELECT
    OrderID,
    ROW_NUMBER() OVER (ORDER BY OrderID) AS rn
FROM sales;


-- Initially, I thought the issue was with the ROW_NUMBER() function. I verified the MySQL version using SELECT VERSION(); to ensure window functions were supported. 
--  Then I checked the table structure with SHOW CREATE TABLE and DESCRIBE to confirm the table and columns existed. 
-- I also checked the SQL mode using SELECT @@sql_mode; to rule out compatibility issues. Finally, 
-- I tested the table with a simple SELECT query and confirmed that ROW_NUMBER() itself worked. 
-- The actual issue was that I was executing multiple SQL statements together in MySQL Workbench instead of executing only the current statement. 
-- Once I executed the ROW_NUMBER() query by itself, it worked correctly.

-- Day 6 – Views & Stored Procedures

-- View 1: vw_CitySales
CREATE VIEW vw_CitySales AS
SELECT
    City,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY City;


-- view2: vw_ProductSales
CREATE VIEW vw_ProductSales AS
SELECT
    product,
        SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_sales
FROM sales
GROUP BY product;

--  View 3: vw_SalespersonPerformance
CREATE VIEW vw_SalespersonPerformance AS
SELECT
    Salesperson,
    COUNT(OrderID) AS Total_Orders,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Salesperson;



-- sales by city (storeed procedures)
DELIMITER $$

CREATE PROCEDURE SalesByCity(IN p_city VARCHAR(100))
BEGIN
    SELECT *
    FROM sales
    WHERE City = p_city;
END $$

DELIMITER ;
 
 -- extra practisce quey ( stored procedure)
-- top 10 customers by reveune
DELIMITER //

CREATE PROCEDURE Top10Customers()
BEGIN
    SELECT CustomerName,
           SUM(Quantity * UnitPrice) AS Revenue
    FROM sales
    GROUP BY CustomerName
    ORDER BY Revenue DESC
    LIMIT 10;
END //

DELIMITER ;

-- calling the above query
CALL Top10Customers();

-- sales by products (stored procedures)

DELIMITER $$
CREATE PROCEDURE SalesByProduct(IN p_product VARCHAR(100))
BEGIN
    SELECT *
    FROM sales
    WHERE Product = p_product;
END $$

DELIMITER 

--   SalesBetweenDates Procedure
DELIMITER $$

CREATE PROCEDURE SalesBetweenDates(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT *
    FROM sales
    WHERE STR_TO_DATE(OrderDate,'%Y-%m-%d')
    BETWEEN start_date AND end_date;
END $$

DELIMITER ;

-- day 6 busssinesss questions

-- top 10 customers
SELECT
    CustomerID,
    CustomerName,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Spending
FROM sales
GROUP BY CustomerID, CustomerName
ORDER BY Total_Spending DESC
LIMIT 10;


-- top 10 products
SELECT
    Product,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Revenue DESC
LIMIT 10;

-- best salesperson
SELECT
    Salesperson,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Salesperson
ORDER BY Total_Revenue DESC
LIMIT 1;

-- worst salesperson
SELECT
    Salesperson,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Salesperson
ORDER BY Total_Revenue ASC
LIMIT 1;


-- highest revenue city
SELECT
    City,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY City
ORDER BY Total_Revenue DESC
LIMIT 1;

-- lowest revenue city
SELECT
    City,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY City
ORDER BY Total_Revenue ASC
LIMIT 1;

-- monthly sales trend
SELECT
    MONTHNAME(OrderDate) AS Month,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Sales
FROM sales
GROUP BY MONTH(OrderDate), MONTHNAME(OrderDate)
ORDER BY MONTH(OrderDate);

--  Category Contribution
SELECT
    Category,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue,
    ROUND(
        SUM(Quantity * UnitPrice) * 100 /
        (SELECT SUM(Quantity * UnitPrice) FROM sales),
        2
    ) AS Contribution_Percentage
FROM sales
GROUP BY Category
ORDER BY Total_Revenue DESC;


-- customer spending rank 
SELECT
    CustomerID,
    CustomerName,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Spending,
    RANK() OVER(ORDER BY SUM(Quantity * UnitPrice) DESC) AS Customer_Rank
FROM sales
GROUP BY CustomerID, CustomerName;


-- which product sholud company promote?
SELECT
    Product,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Quantity * UnitPrice),2) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Quantity_Sold ASC,
         Total_Revenue ASC
LIMIT 1;

