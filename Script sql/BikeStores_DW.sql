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


select * from  cargarFTVentas 
insert into cargarFTVentas (UltimaCarga) values (getdate())

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

CREATE TABLE dbo.DimCustomers(
    CustomerKey INT IDENTITY(1,1) NOT NULL,
    CustomerID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(25) NULL,
    Email VARCHAR(255) NOT NULL,
    Street VARCHAR(255) NULL,
    City VARCHAR(50) NULL,
    State VARCHAR(25) NULL,
    ZipCode VARCHAR(5) NULL,
    CONSTRAINT PK_DimCustomers PRIMARY KEY(CustomerKey)
);
GO


CREATE TABLE dbo.DimCustomers_Hist(
    CustomerID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
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


CREATE TABLE dbo.DimStaff(
    StaffKey INT IDENTITY(1,1) NOT NULL,
    StaffID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(25) NULL,
    Active TINYINT NOT NULL,
    StoreID INT NOT NULL,
    ManagerID INT NULL,
    CONSTRAINT PK_DimStaff PRIMARY KEY(StaffKey)
);
GO


CREATE TABLE dbo.DimStaff_Hist(
    StaffID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
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
CREATE TABLE DimProducts_Hist(
  ProductID INT NOT NULL,
  ProductName VARCHAR(255)  NOT NULL,
  BrandID INT NOT NULL,
  BrandName VARCHAR(255)  NOT NULL,
  CategoryID INT NOT NULL,
  CategoryName VARCHAR(255) NOT NULL,
  ModelYear SMALLINT NOT NULL,
  ListPrice DECIMAL(10,2) NOT NULL,
  StartDate DATETIME NOT NULL,
  EndDate DATETIME NULL
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
create table dbo.DimStocks(
    StockKey int identity(1,1) not null,
    StoreID int not null,
    ProductID int not null,
    Quantity int null,
    constraint PK_DimStocks primary key(StockKey)
);


create table dbo.FactSales(
    SalesKey int identity(1,1) not null,
    ProductKey int not null,
    CustomerKey int not null,
    StaffKey int not null,
    StoreKey int not null,
    OrderKey int not null,
    OrderDateKey int not null,
    RequiredDateKey int null,
    ShippedDateKey int null,
    Quantity int not null,
    ListPrice decimal(10,2) not null,
    Discount decimal(4,2) not null,
    AmountGross decimal(18,2) not null,
    AmountDiscount decimal(18,2) not null,
    AmountNet decimal(18,2) not null,
    constraint PK_FactSales primary key clustered (SalesKey asc)
);
go

alter table dbo.FactSales with check add foreign key(ProductKey)
    references dbo.DimProducts(ProductKey);
alter table dbo.FactSales with check add foreign key(CustomerKey)
    references dbo.DimCustomers(CustomerKey);
alter table dbo.FactSales with check add foreign key(StaffKey)
    references dbo.DimStaff(StaffKey);
alter table dbo.FactSales with check add foreign key(StoreKey)
    references dbo.DimStores(StoreKey);
alter table dbo.FactSales with check add foreign key(OrderKey)
    references dbo.DimOrders(OrdersKey);
alter table dbo.FactSales with check add foreign key(OrderDateKey)
    references dbo.DimDate(DateKey);
alter table dbo.FactSales with check add foreign key(RequiredDateKey)
    references dbo.DimDate(DateKey);
alter table dbo.FactSales with check add foreign key(ShippedDateKey)
    references dbo.DimDate(DateKey);
go



