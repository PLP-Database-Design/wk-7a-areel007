-- Question 1 Achieving 1NF (First Normal Form) 🛠️
-- The Products column contains multiple values in the same row, which violates 1NF.
-- We will transform this into 1NF by ensuring each row represents a single product for an order.

-- Original table: ProductDetail (OrderID, CustomerName, Products)
-- Transforming this table into 1NF involves creating a new row for each product.

-- SQL query to achieve 1NF:
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
  ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
ORDER BY OrderID, Product;

-- Explanation:
-- We use the `SUBSTRING_INDEX` function along with a number sequence (represented by `n`) to split the `Products` column into separate rows.
-- Each product is extracted from the comma-separated list in the `Products` column.
-- The result is that each order has a single product per row, achieving 1NF.

-- Question 2 Achieving 2NF (Second Normal Form) 🧩
-- The table OrderDetails is in 1NF but contains a partial dependency between OrderID and CustomerName.
-- To transform this into 2NF, we need to remove the partial dependency by creating a separate table for CustomerName.

-- Original table: OrderDetails (OrderID, CustomerName, Product, Quantity)
-- We will split the table into two: 
-- One table for orders with OrderID and CustomerName, and
-- Another table for the order details with OrderID, Product, and Quantity.

-- Step 1: Create a new table to store unique OrderID and CustomerName information:
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create a new table to store OrderID, Product, and Quantity information:
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Insert data into the Orders table:
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 4: Insert data into the OrderProducts table:
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Explanation:
-- We split the original table into two:
-- 1. `Orders` table stores OrderID and CustomerName, ensuring CustomerName only depends on OrderID (removing partial dependency).
-- 2. `OrderProducts` table stores OrderID, Product, and Quantity, with OrderID as a foreign key.
-- Now, each non-key column fully depends on the entire primary key in the `OrderProducts` table.
