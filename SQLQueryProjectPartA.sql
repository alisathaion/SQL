USE MASTER;
GO



/*CREATE DATABASE cus_orders*/
IF exists (SELECT * FROM sysdatabases WHERE name='Cus_Orders')
BEGIN
  RAISERROR('Dropping existing Cus_Orders ....',0,1)
  DROP DATABASE Cus_Orders
END
GO



CREATE DATABASE Cus_Orders;
GO



USE Cus_Orders;
GO



/*Create User-defined Data Type*/
CREATE TYPE idchartype FROM char(5) NOT NULL;
CREATE TYPE idinttype FROM int NOT NULL;
GO



/*Create table customers into database Cus_orders*/
CREATE TABLE customers
(
customer_id idchartype,
name varchar(50) NOT NULL,
contact_name varchar(30),
title_id char(3) NOT NULL,
address varchar(50),
city varchar(20),
region varchar(15),
country_code varchar(10),
country varchar(15),
phone varchar(20),
fax varchar(20)
);
GO



/*Create table orders*/
CREATE TABLE orders
(
order_id idinttype,
customer_id idchartype,
employee_id int NOT NULL,
shipping_name varchar(50),
shipping_address varchar(50),
shipping_city varchar(20),
shipping_region varchar(15),
shipping_country_code varchar(10),
shipping_country varchar(15),
shipper_id int NOT NULL,
order_date datetime,
required_date datetime,
shipped_date datetime,
freight_charge money
);
GO



/*Create table order_details*/
CREATE TABLE order_details
(
order_id idinttype,
product_id idinttype,
quantity int NOT NULL,
discount float NOT NULL
);
GO



/*Create table products*/
CREATE TABLE products
(
product_id idinttype,
supplier_id int NOT NULL,
name varchar(40) NOT NULL,
alternate_name varchar(40),
quantity_per_unit varchar(25),
unit_price money,
quantity_in_stock int,
units_on_order int,
reorder_level int
);
GO



/*Create table shippers*/
CREATE TABLE shippers
(
shipper_id int IDENTITY NOT NULL,
name varchar(20) NOT NULL
);
GO



/*Create table suppliers*/
CREATE TABLE suppliers
(
supplier_id int IDENTITY NOT NULL,
name varchar(40) NOT NULL,
address varchar(30),
city varchar(20),
province char(2)
);
GO



/*Create table titles*/
CREATE TABLE titles
(
title_id char(3) NOT NULL,
description varchar(35) NOT NULL
);
GO



/*define primary key for customers*/
ALTER TABLE customers
ADD PRIMARY KEY(customer_id);
GO



/*define primary key for order_details*/
ALTER TABLE order_details
ADD PRIMARY KEY(order_id,product_id);
GO



/*define primary key for orders*/
ALTER TABLE orders
ADD PRIMARY KEY(order_id);
GO



/*define primary key for products*/
ALTER TABLE products
ADD PRIMARY KEY(product_id);
GO



/*define primary key for shippers*/
ALTER TABLE shippers
ADD PRIMARY KEY(shipper_id);
GO



/*define primary key for suppliers*/
ALTER TABLE suppliers
ADD PRIMARY KEY(supplier_id);
GO



/*define primary key for titles*/
ALTER TABLE titles
ADD PRIMARY KEY(title_id);
GO



/*define foreign key for customers*/
ALTER TABLE customers
ADD CONSTRAINT fk_customers_title FOREIGN KEY(title_id)
REFERENCES titles(title_id);
GO



/*define foreign key for order_details*/
ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_product FOREIGN KEY(product_id)
REFERENCES products(product_id);
GO



/*define foreign key for order_details*/
ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_orders FOREIGN KEY(order_id)
REFERENCES orders(order_id);
GO



/*define foreign key for orders*/
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers FOREIGN KEY(customer_id)
REFERENCES customers(customer_id);
GO



/*define foreign key for orders*/
ALTER TABLE orders
ADD CONSTRAINT fk_orders_shippers FOREIGN KEY(shipper_id)
REFERENCES shippers(shipper_id);
GO



/*define foreign key for products*/
ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers FOREIGN KEY(supplier_id)
REFERENCES suppliers(supplier_id);
GO



/*Set constraints default country for customers*/
ALTER TABLE customers
ADD CONSTRAINT default_country
DEFAULT('Canada') FOR country;
GO



/*Set constraints default required date for orders*/
ALTER TABLE orders
ADD CONSTRAINT default_required_date
DEFAULT(DATEADD(DAY,10,GETDATE())) FOR required_date;
GO



/*Set constraints check quantity for order_details*/
ALTER TABLE order_details
ADD CONSTRAINT ck_quantity
CHECK(quantity>=1);
GO



/*Set constraints check reorder level for products*/
ALTER TABLE products
ADD CONSTRAINT ck_reorder_level
CHECK(reorder_level>=1);
GO



/*Set constraints check quantity in stock for products*/
ALTER TABLE products
ADD CONSTRAINT ck_quantity_in_stock
CHECK(quantity_in_stock>150);
GO



/*Set constraints default province for suppliers*/
ALTER TABLE suppliers
ADD CONSTRAINT default_province
DEFAULT('BC') FOR province;
GO
