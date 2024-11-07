-- Example of bad naming conventions in T-SQL
/*
tbl1 is not descriptive. A better name would be Customers or Orders.
id, nm, and dt are not descriptive. Better names would be CustomerID, Name, and OrderDate.
sp1 is not descriptive. A better name would be GetAllCustomers or GetAllOrders.

*/


-- Poorly named table
CREATE TABLE tbl1 (
    id INT PRIMARY KEY,
    nm VARCHAR(100),
    dt DATETIME
);

-- Poorly named stored procedure
CREATE PROCEDURE sp1
AS
BEGIN
    SELECT * FROM tbl1;
END;

-- Poorly named column in a query
SELECT id, nm, dt FROM tbl1;