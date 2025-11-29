CREATE DATABASE BikeStores_Stage;
GO
GO
CREATE SCHEMA production;
GO
CREATE SCHEMA sales;
GO
USE BikeStores_Stage;

/*
-- drop tables
DROP TABLE IF EXISTS sales.order_items;
DROP TABLE IF EXISTS sales.orders;

DROP TABLE IF EXISTS sales.customers;
DROP TABLE IF EXISTS sales.staffs;
DROP TABLE IF EXISTS sales.stores;
DROP TABLE IF EXISTS production.stocks;
DROP TABLE IF EXISTS production.products;
DROP TABLE IF EXISTS production.categories;
DROP TABLE IF EXISTS production.brands;

-- drop the schemas

DROP SCHEMA IF EXISTS sales;
DROP SCHEMA IF EXISTS production;
*/



CREATE TABLE production.categories(
	category_id INT NOT NULL,
	category_name VARCHAR(255) NOT NULL
);
CREATE TABLE production.brands(
	brand_id INT NOT NULL,
	brand_name VARCHAR(255) NOT NULL
);
CREATE TABLE production.products(
	product_id INT NOT NULL,
	product_name VARCHAR(255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL(10,2) NOT NULL
);
CREATE TABLE production.stocks(
	store_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NULL
);
CREATE TABLE sales.customers(
	customer_id INT NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	phone VARCHAR(25) NULL,
	email VARCHAR(255) NOT NULL,
	street VARCHAR(255) NULL,
	city VARCHAR(50) NULL,
	state VARCHAR(25) NULL,
	zip_code VARCHAR(5) NULL
);
CREATE TABLE sales.stores(
	store_id INT NOT NULL,
	store_name VARCHAR(255) NOT NULL,
	phone VARCHAR(25) NULL,
	email VARCHAR(255) NULL,
	street VARCHAR(255) NULL,
	city VARCHAR(255) NULL,
	state VARCHAR(10) NULL,
	zip_code VARCHAR(5) NULL
);
CREATE TABLE sales.staffs(
	staff_id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(255) NOT NULL,
	phone VARCHAR(25) NULL,
	active TINYINT NOT NULL,
	store_id INT NOT NULL,
	manager_id INT NULL
);

CREATE TABLE sales.orders(
	order_id INT NOT NULL,
	customer_id INT NULL,
	order_status TINYINT NOT NULL,
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE NULL,
	store_id INT NOT NULL,
	staff_id INT NOT NULL
);

CREATE TABLE sales.order_items(
	order_id INT NOT NULL,
	item_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL(10,2) NOT NULL,
	discount DECIMAL(4,2) NOT NULL
);