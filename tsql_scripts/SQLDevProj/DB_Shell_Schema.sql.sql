-- Create Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);
GO
-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    OrderAmount DECIMAL(10, 2) NOT NULL,
    OrderStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
GO
-- Create Invoice table
CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO
-- Create Invoice_Detail table
CREATE TABLE Invoice_Detail (
    InvoiceDetailID INT PRIMARY KEY IDENTITY(1,1),
    InvoiceID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID)
);-- Write your own SQL object definition here, and it'll be included in your package.
GO
-- Create Product table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    ProductDescription VARCHAR(255),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);
GO