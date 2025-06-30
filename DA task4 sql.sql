SELECT TOP (1000) [transaction_id]
      ,[user_id]
      ,[product_category]
      ,[payment_method]
      ,[transaction_amount]
      ,[purchase_date]
      ,[delivery_status]
  FROM [Ecommerece_data_].[dbo].[ecommerce_transactions_dataset]
  --a. SELECT, WHERE, ORDER BY, GROUP BY
  SELECT user_id, COUNT(transaction_id) AS total_orders, SUM(transaction_amount) AS total_spent
FROM ecommerce_transactions_dataset
WHERE delivery_status = 'Delivered'
GROUP BY user_id
ORDER BY total_spent DESC;
select * from ecommerce_transactions_dataset

--b.Use JOINS (INNER, LEFT, RIGHT)
--since we have only one table so we cannot use the joints. so i am creating new table and mke the joins

CREATE TABLE product_details (
    product_category VARCHAR(50) PRIMARY KEY,
    average_price DECIMAL(10, 2),
    total_stock INT,
    brand_popularity VARCHAR(20)
);
INSERT INTO product_details (product_category, average_price, total_stock, brand_popularity) VALUES
('Beauty', 1200.00, 500, 'High'),
('Home', 3500.00, 300, 'Medium'),
('Electronics', 15000.00, 200, 'High'),
('Clothing', 1800.00, 800, 'Medium'),
('Grocery', 750.00, 1000, 'Low'),
('Toys', 950.00, 600, 'Medium'),
('Furniture', 8200.00, 150, 'High'),
('Books', 550.00, 900, 'Low'),
('Fitness', 2200.00, 350, 'Medium'),
('Stationery', 300.00, 700, 'Low'),
('Appliances', 9800.00, 120, 'High'),
('Footwear', 2500.00, 450, 'Medium'),
('Gaming', 12500.00, 180, 'High'),
('Jewellery', 10500.00, 100, 'High'),
('Kitchenware', 1600.00, 500, 'Medium');

--Inner join
SELECT 
    et.transaction_id,
    et.product_category,
    et.transaction_amount,
    pd.average_price,
    pd.total_stock,
    pd.brand_popularity
FROM ecommerce_transactions_dataset et
INNER JOIN product_details pd 
ON et.product_category = pd.product_category;

--Left Join
SELECT 
    et.transaction_id,
    et.user_id,
    et.product_category,
    et.transaction_amount,
    pd.average_price,
    pd.total_stock,
    pd.brand_popularity
FROM ecommerce_transactions_dataset et
LEFT JOIN product_details pd 
ON et.product_category = pd.product_category;

--Right Join
SELECT 
    pd.product_category,
    pd.average_price,
    pd.total_stock,
    et.transaction_id,
    et.transaction_amount,
    et.user_id
FROM ecommerce_transactions_dataset et
RIGHT JOIN product_details pd 
ON et.product_category = pd.product_category;

--c.Write subqueries
SELECT * 
FROM ecommerce_transactions_dataset
WHERE user_id IN (
    SELECT user_id 
    FROM ecommerce_transactions_dataset
    GROUP BY user_id
    HAVING SUM(transaction_amount) > 3400
);
--d.Use aggregate functions (SUM, AVG)
SELECT 
    product_category,
    SUM(transaction_amount) AS total_sales,
    AVG(transaction_amount) AS avg_order_value
FROM ecommerce_transactions_dataset
GROUP BY product_category;

--e.Create views for analysis
SELECT 
    user_id, 
    SUM(transaction_amount) AS total_spent
FROM ecommerce_transactions_dataset
GROUP BY user_id
HAVING SUM(transaction_amount) > 2000;

--f.Optimize queries with indexes
-- Index to speed up user-based queries
CREATE INDEX idx_user_id ON ecommerce_transactions_dataset(user_id);

-- Index to speed up category-based joins
CREATE INDEX idx_product_category ON ecommerce_transactions_dataset(product_category);

-- Index for faster date filtering
CREATE INDEX idx_purchase_date ON ecommerce_transactions_dataset(purchase_date);

SELECT * FROM ecommerce_transactions_dataset WHERE user_id = 'U6755';
SELECT * FROM ecommerce_transactions_dataset WHERE purchase_date >= '2024-01-01';
