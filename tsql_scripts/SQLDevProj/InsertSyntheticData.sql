-- Create stored procedure to insert synthetic data into tables
CREATE PROCEDURE InsertSyntheticData
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert synthetic data into Customer table
    DECLARE @i INT = (SELECT ISNULL(MAX(CustomerID), 0) + 1 FROM Customer);
    WHILE @i < (SELECT ISNULL(MAX(CustomerID), 0) + 101 FROM Customer)
    BEGIN
        INSERT INTO Customer (CustomerName, Email, Phone, Address)
        VALUES (
            CONCAT('Customer', @i),
            CONCAT('customer', @i, '@example.com'),
            CONCAT('123-456-789', @i % 10),
            CONCAT('Address ', @i)
        );
        SET @i = @i + 1;
    END;

    -- Insert synthetic data into Orders table
    SET @i = (SELECT ISNULL(MAX(OrderID), 0) + 1 FROM Orders);
    WHILE @i < (SELECT ISNULL(MAX(OrderID), 0) + 101 FROM Orders)
    BEGIN
        INSERT INTO Orders (CustomerID, OrderDate, OrderAmount, OrderStatus)
        VALUES (
            @i,
            DATEADD(DAY, -@i, GETDATE()),
            ROUND(RAND() * 1000, 2),
            CASE WHEN @i % 3 = 0 THEN 'Shipped' WHEN @i % 3 = 1 THEN 'Pending' ELSE 'Cancelled' END
        );
        SET @i = @i + 1;
    END;

    -- Insert synthetic data into Invoice table
    SET @i = (SELECT ISNULL(MAX(InvoiceID), 0) + 1 FROM Invoice);
    WHILE @i < (SELECT ISNULL(MAX(InvoiceID), 0) + 101 FROM Invoice)
    BEGIN
        INSERT INTO Invoice (OrderID, InvoiceDate, TotalAmount)
        VALUES (
            @i,
            DATEADD(DAY, -@i, GETDATE()),
            ROUND(RAND() * 1000, 2)
        );
        SET @i = @i + 1;
    END;

    -- Insert synthetic data into Product table
    SET @i = (SELECT ISNULL(MAX(ProductID), 0) + 1 FROM Product);
    WHILE @i < (SELECT ISNULL(MAX(ProductID), 0) + 101 FROM Product)
    BEGIN
        INSERT INTO Product (ProductName, ProductDescription, Price, StockQuantity)
        VALUES (
            CONCAT('Product', @i),
            CONCAT('Description for product ', @i),
            ROUND(RAND() * 100, 2),
            FLOOR(RAND() * 1000)
        );
        SET @i = @i + 1;
    END;

    -- Insert synthetic data into Invoice_Detail table
    SET @i = (SELECT ISNULL(MAX(InvoiceDetailID), 0) + 1 FROM Invoice_Detail);
    WHILE @i < (SELECT ISNULL(MAX(InvoiceDetailID), 0) + 101 FROM Invoice_Detail)
    BEGIN
        INSERT INTO Invoice_Detail (InvoiceID, ProductID, Quantity, UnitPrice)
        VALUES (
            @i,
            @i,
            FLOOR(RAND() * 10) + 1,
            ROUND(RAND() * 100, 2)
        );
        SET @i = @i + 1;
    END;
END;