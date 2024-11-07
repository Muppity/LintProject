CREATE PROCEDURE spGetCustomerOrders
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Fetch customer orders based on CustomerId
    SELECT o.OrderId, o.OrderDate, o.TotalAmount
    FROM Orders o
    INNER JOIN Customer c ON o.CustomerId = c.CustomerId
    WHERE o.CustomerId = @CustomerId;
END;
