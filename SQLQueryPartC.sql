USE Cus_Orders



/*C 1. Create an employee table */
CREATE TABLE employee
(
employee_id int NOT NULL,
last_name varchar(30) NOT NULL,
first_name varchar(15) NOT NULL,
address varchar(30),
city varchar(20),
province char(2),
postal_code varchar(7),
phone varchar(10),
birth_date datetime NOT NULL
);
GO



/*C 2. Define primary key for the employee table */
ALTER TABLE employee
ADD PRIMARY KEY(employee_id);
GO



/*C 3. Load the data into the employee table from the employee.txt file. And create the 
relationship to enforce referential integrity between the employee and orders tables*/
BULK INSERT employee 
FROM 'C:\TextFiles\employee.txt' 
WITH (         CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )
GO
/*Define Foreign Key*/
ALTER TABLE orders
ADD CONSTRAINT fk_orders_employee 
FOREIGN KEY(employee_id)
REFERENCES employee(employee_id);
GO



/*C 4. INSERT the shipper Quick Express to the shippers table*/
INSERT INTO shippers (name)
VALUES('Quick Express');
GO



/*C 5. UPDATE the unit price in the products table of all rows with a current unit price 
between $5.00 and $10.00 by increase 5%*/
UPDATE products
SET unit_price = ROUND(((unit_price*0.05)+unit_price),2)
WHERE unit_price BETWEEN 5.00 AND 10.00;
GO 



/*C 6. UPDATE the fax value to Unknown for all rows in the customers table where the current 
fax value is NULL*/
UPDATE customers
SET fax = 'Unknown'
WHERE fax is NULL;
GO



/*C 7. Create a view called vw_order_cost to list the cost of the orders.  
List the order id and order_date from the orders table, the product id from the products table,
the customer name from the customers table, and the order cost.*/
CREATE VIEW vw_order_cost
AS
SELECT 
orders.order_id,
orders.order_date,
products.product_id,
customers.name,
'order cost' = order_details.quantity*products.unit_price
FROM orders 
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON products.product_id = order_details.product_id;
GO
/*Run the view for the order ids between 10000 and 10200*/
SELECT *
FROM vw_order_cost
WHERE order_id BETWEEN 10000 AND 10200;
GO



/*C 8. Create a view called vw_list_employees to list all the employees and all the columns 
in the employee table.*/
CREATE VIEW vw_list_employees
AS
SELECT *
FROM employee;
GO
/*Run the view for employee ids 5, 7, and 9. Display the employee id, last name, first name, 
and birth date.*/
SELECT 
employee_id,
'name'= last_name+', '+first_name,
'birth_date'= CONVERT(char(10),birth_date,102)
FROM vw_list_employees
WHERE employee_id IN (5,7,9);
GO



/*C 9. Create a view called vw_all_orders to list the columns shown below.  
Display the order id and shipped date from the orders table, and the customer id, name, city, 
and country from the customers table.*/
CREATE VIEW vw_all_orders
AS
SELECT 
orders.order_id,
customers.customer_id,
'customer_name'=customers.name,
customers.city,
customers.country,
orders.shipped_date
FROM orders 
INNER JOIN customers ON orders.customer_id = customers.customer_id;
GO
/*Run the view for orders shipped from August 1, 2002 and September 30, 2002. Order the result set
by customer name and country*/
SELECT
order_id,
customer_id,
customer_name,
city,
country,
'shipped_date'=CONVERT(char(12),shipped_date,107)
FROM vw_all_orders
WHERE shipped_date BETWEEN 'Aug 1 2002' AND 'Sep 30 2002'
ORDER BY customer_name,country;
GO



/*C 10.	Create a view listing the suppliers and the items they have shipped
Display the supplier id and name from the suppliers table, and the product id and name 
from the products table.*/
CREATE VIEW vw_suppliers_items_shipped
AS
SELECT 
suppliers.supplier_id,
'supplier_name'=suppliers.name,
products.product_id,
'product_name'=products.name
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id;
GO
/*Run the view*/
SELECT *
FROM vw_suppliers_items_shipped;
GO
