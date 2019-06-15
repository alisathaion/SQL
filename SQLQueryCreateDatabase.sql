/* Make sure the Master database (the overall container database ) is selected */
USE master;
GO

/*Check if the database already exists – if it does drop it */
IF exists (SELECT * FROM sysdatabases WHERE name='customer_sales')
BEGIN
  RAISERROR('Dropping existing Cus_Orders ....',0,1)
  DROP DATABASE customer_sales
END
GO

/* Create THE customer_sales database */
CREATE DATABASE customer_sales;
GO

/*Set the newly created database as the current database – very important */
USE customer_sales;
GO

/*Create user type */
CREATE TYPE csid FROM char(10) NOT NULL;
GO

/* Create customer table */
CREATE TABLE customer
(
cus_code	csid,
cus_lname	varchar(30) NOT NULL,
cus_fname	varchar(20),
cus_initial	char(1),
cus_areacode	char(3),
cus_phone	char(8),
cus_balance	smallmoney
);
GO

/* Create Invoice table */
CREATE TABLE invoice
( 
 inv_number	csid, 
 cus_code      	csid,
 inv_date       datetime,
 inv_net      	smallmoney,
 inv_tax        smallmoney,
 inv_total      smallmoney
 );
GO