create database BikeStores_DW;
GO

USE BikeStores_DW;
GO

CREATE TABLE cargarFTVentas(
  CargaKey INT IDENTITY(1,1) NOT NULL,
  UltimaCarga DATETIME NOT NULL,
  CONSTRAINT PK_cargarFTVentas PRIMARY KEY (CargaKey)
);
GO

CREATE TABLE dbo.DimDate(
    DateKey INT NOT NULL PRIMARY KEY, 
    [Date] DATE NOT NULL,
    FullDateUK CHAR(10),     
    FullDateUSA CHAR(10),     
    DayOfMonth TINYINT,      
    DaySuffix VARCHAR(4),
    DayName VARCHAR(9),
    DayOfWeekUSA TINYINT,     
    DayOfWeekUK TINYINT,      
    DayOfWeekInMonth TINYINT,
    DayOfWeekInYear SMALLINT,
    DayOfQuarter SMALLINT,
    DayOfYear SMALLINT,
    WeekOfMonth TINYINT,
    WeekOfQuarter TINYINT,
    WeekOfYear TINYINT,
    [Month] TINYINT, 
    MonthName VARCHAR(9),
    MonthOfQuarter TINYINT,
    [Quarter] TINYINT,   
    QuarterName VARCHAR(9),
    [Year] SMALLINT,
    YearName CHAR(7),
    MonthYear CHAR(10),
    MMYYYY CHAR(6),
    FirstDayOfMonth DATE,
    LastDayOfMonth DATE,
    FirstDayOfQuarter DATE,
    LastDayOfQuarter DATE,
    FirstDayOfYear DATE,
    LastDayOfYear DATE,
    IsHolidayUSA BIT,
    IsWeekday BIT,
    HolidayUSA VARCHAR(50),
    IsHolidayUK BIT NULL,
    HolidayUK VARCHAR(50) NULL
);
GO

CREATE TABLE DimCustomers(
  CustomerKey INT IDENTITY(1,1) NOT NULL,
  CustomerID INT NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  Phone VARCHAR(25) NULL,
  Email VARCHAR(255) NOT NULL,
  Street VARCHAR(255) NULL,
  City VARCHAR(50) NULL,
  State VARCHAR(25) NULL,
  ZipCode VARCHAR(5) NULL,
  CONSTRAINT PK_DimCustomers PRIMARY KEY (CustomerKey)
);
GO

CREATE TABLE DimCustomers_Hist(
  CustomerID INT NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  Phone VARCHAR(25) NULL,
  Email VARCHAR(255) NOT NULL,
  Street VARCHAR(255) NULL,
  City VARCHAR(50) NULL,
  State VARCHAR(25) NULL,
  ZipCode VARCHAR(5) NULL,
  StartDate DATETIME NOT NULL,
  EndDate DATETIME NULL
);
GO

CREATE TABLE DimStaff(
  StaffKey INT IDENTITY(1,1) NOT NULL,
  StaffID INT NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(255) NOT NULL,
  Phone VARCHAR(25) NULL,
  Active TINYINT NOT NULL,
  StoreID INT NOT NULL,
  ManagerID INT NULL,
  CONSTRAINT PK_DimStaff PRIMARY KEY (StaffKey)
);
GO

CREATE TABLE DimStaff_Hist(
  StaffID INT NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(255) NOT NULL,
  Phone VARCHAR(25) NULL,
  Active TINYINT NOT NULL,
  StoreID INT NOT NULL,
  ManagerID INT NULL,
  StartDate DATETIME NOT NULL,
  EndDate DATETIME NULL
);
GO

CREATE TABLE DimStores(
  StoreKey INT IDENTITY(1,1) NOT NULL,
  StoreID INT NOT NULL,
  StoreName VARCHAR(255) NOT NULL,
  Phone VARCHAR(25) NULL,
  Email VARCHAR(255) NULL,
  Street VARCHAR(255) NULL,
  City VARCHAR(255) NULL,
  State VARCHAR(10) NULL,
  ZipCode VARCHAR(5) NULL,
  CONSTRAINT PK_DimStores PRIMARY KEY (StoreKey)
);
GO

CREATE TABLE DimProducts(
  ProductKey INT IDENTITY(1,1) NOT NULL,
  ProductID INT NOT NULL,
  ProductName VARCHAR(255) NOT NULL,
  BrandID INT NOT NULL,
  BrandName VARCHAR(255) NOT NULL,
  CategoryID INT NOT NULL,
  CategoryName VARCHAR(255) NOT NULL,
  ModelYear SMALLINT NOT NULL,
  ListPrice DECIMAL(10,2) NOT NULL,
  CONSTRAINT PK_DimProducts PRIMARY KEY (ProductKey)
);
GO

CREATE TABLE DimOrders(
  OrdersKey INT IDENTITY(1,1) NOT NULL,
  OrderID INT NOT NULL,
  OrderStatus TINYINT NOT NULL,
  StoreID INT NOT NULL,
  StaffID INT NOT NULL,
  CustomerID INT NULL,
  CONSTRAINT PK_DimOrders PRIMARY KEY (OrdersKey)
);
GO

CREATE TABLE FactSales(
  SalesKey INT IDENTITY(1,1) NOT NULL,
  ProductKey INT NOT NULL,
  CustomerKey INT NOT NULL,
  StaffKey INT NOT NULL,
  StoreKey INT NOT NULL,
  OrderKey INT NOT NULL,
  OrderDateKey INT NOT NULL,
  RequiredDateKey INT NOT NULL,
  ShippedDateKey INT NULL,
  Quantity INT NOT NULL,
  ListPrice DECIMAL(10,2) NOT NULL,
  Discount DECIMAL(4,2) NOT NULL,
  AmountGross DECIMAL(18,2) NOT NULL,
  AmountDiscount DECIMAL(18,2) NOT NULL,
  AmountNet DECIMAL(18,2) NOT NULL,
  CONSTRAINT PK_FactSales PRIMARY KEY CLUSTERED (SalesKey ASC)
);
GO

ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(ProductKey)
REFERENCES DimProducts(ProductKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(CustomerKey)
REFERENCES DimCustomers(CustomerKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(StaffKey)
REFERENCES DimStaff(StaffKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(StoreKey)
REFERENCES DimStores(StoreKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(OrderKey)
REFERENCES DimOrders(OrdersKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(OrderDateKey)
REFERENCES DimDate(DateKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(RequiredDateKey)
REFERENCES DimDate(DateKey);
ALTER TABLE FactSales WITH CHECK ADD FOREIGN KEY(ShippedDateKey)
REFERENCES DimDate(DateKey);
GO

