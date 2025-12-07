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

create table dbo.DimDate(
    DateKey int not null,
    [Date] date null,
    FullDateUK char(10) null,
    FullDateUSA char(10) null,
    DayOfMonth varchar(2) null,
    DaySuffix varchar(4) null,
    DayName varchar(9) null,
    DayOfWeekUSA char(1) null,
    DayOfWeekUK char(1) null,
    DayOfWeekInMonth varchar(2) null,
    DayOfWeekInYear varchar(2) null,
    DayOfQuarter varchar(3) null,
    DayOfYear varchar(3) null,
    WeekOfMonth varchar(1) null,
    WeekOfQuarter varchar(2) null,
    WeekOfYear varchar(2) null,
    [Month] varchar(2) null,
    MonthName varchar(9) null,
    MonthOfQuarter varchar(2) null,
    [Quarter] char(1) null,
    QuarterName varchar(9) null,
    [Year] char(4) null,
    YearName char(7) null,
    MonthYear char(10) null,
    MMYYYY char(6) null,
    FirstDayOfMonth date null,
    LastDayOfMonth date null,
    FirstDayOfQuarter date null,
    LastDayOfQuarter date null,
    FirstDayOfYear date null,
    LastDayOfYear date null,
    IsHolidayUSA bit null,
    IsWeekday bit null,
    HolidayUSA varchar(50) null,
    IsHolidayUK bit null,
    HolidayUK varchar(50) null,
    constraint PK_DimDate primary key clustered (DateKey)
);


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


