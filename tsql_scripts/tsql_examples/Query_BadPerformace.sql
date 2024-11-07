-- Example of bad query practices in T-SQL
/*

Heavy Cursors: Using cursors for row-by-row processing instead of set-based operations.
Scalar UDFs in SELECT Clause: Using scalar user-defined functions in the SELECT clause, which can lead to performance issues.
Non-SARGable Queries: Using functions on columns in the WHERE clause, making the query non-SARGable (e.g., CONVERT(VARCHAR, OrderDate, 101)).
Different Data Types in WHERE Clause: Comparing columns with different data types (e.g., OrderAmount = '100.00').
Query Hints (NOLOCK): Using NOLOCK hint, which can lead to dirty reads and inconsistent data.

*/
-- Create a table with various data types
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    OrderAmount DECIMAL(10, 2),
    OrderStatus VARCHAR(50)
);

-- Insert some sample data
INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderAmount, OrderStatus)
VALUES (1, 101, '2023-01-01', 100.00, 'Shipped'),
       (2, 102, '2023-01-02', 200.00, 'Pending'),
       (3, 103, '2023-01-03', 300.00, 'Cancelled');

-- Scalar UDF
CREATE FUNCTION dbo.GetOrderStatus(@OrderID INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @Status VARCHAR(50);
    SELECT @Status = OrderStatus FROM Orders WHERE OrderID = @OrderID;
    RETURN @Status;
END;

-- Cursor example
DECLARE @OrderID INT;
DECLARE @CustomerID INT;
DECLARE @OrderDate DATETIME;
DECLARE @OrderAmount DECIMAL(10, 2);
DECLARE @OrderStatus VARCHAR(50);

DECLARE order_cursor CURSOR FOR
SELECT OrderID, CustomerID, OrderDate, OrderAmount, OrderStatus
FROM Orders WITH (NOLOCK);

OPEN order_cursor;
FETCH NEXT FROM order_cursor INTO @OrderID, @CustomerID, @OrderDate, @OrderAmount, @OrderStatus;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Using scalar UDF in SELECT clause
    SELECT @OrderID, @CustomerID, @OrderDate, @OrderAmount, dbo.GetOrderStatus(@OrderID);

    FETCH NEXT FROM order_cursor INTO @OrderID, @CustomerID, @OrderDate, @OrderAmount, @OrderStatus;
END;

CLOSE order_cursor;
DEALLOCATE order_cursor;

-- Non-SARGable query with different data types in WHERE clause
SELECT *
FROM Orders WITH (NOLOCK)
WHERE CONVERT(VARCHAR, OrderDate, 101) = '01/01/2023'
  AND OrderAmount = '100.00';