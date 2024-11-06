-- Create a nested query with different data types in the JOIN clause

/*
Different Data Types in JOIN Clause: The JOIN condition uses CustomerID from Orders and CustomerCode from Customers, with CustomerCode being cast to INT.
Different Data Types in WHERE Clause: The WHERE clause compares OrderAmount (DECIMAL) with a string '100.00'.

*/

-- Create another table with various data types
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerCode VARCHAR(10)
);

-- Insert some sample data
INSERT INTO Customers (CustomerID, CustomerName, CustomerCode)
VALUES (101, 'John Doe', 'C101'),
       (102, 'Jane Smith', 'C102'),
       (103, 'Bob Johnson', 'C103');

-- Nested query with different data types in the JOIN clause
SELECT o.OrderID, o.OrderDate, o.OrderAmount, c.CustomerName
FROM Orders o
JOIN (
    SELECT CustomerID, CustomerName, CustomerCode
    FROM Customers
) c ON o.CustomerID = CAST(c.CustomerCode AS INT)
WHERE o.OrderAmount = '100.00';