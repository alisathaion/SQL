USE Cus_Orders;



/*D 1. Create a stored procedure called sp_customer_city. Display the customer id, name, address, 
city and phone from the customers table.*/
CREATE PROCEDURE sp_customer_city
(
       @city varchar(20)
)
AS
SELECT customer_id,name,address,city,phone
FROM customers
WHERE city = @city
GO
/*Run the stored procedure displaying customers living in London*/
EXECUTE sp_customer_city 'London'



/*D 2. Create a stored procedure called sp_orders_by_dates displaying the orders shipped between 
particular dates. Display the order id, customer id, and shipped date from the orders table, 
the customer name from the customer table, and the shipper name from the shippers table.*/  
CREATE PROCEDURE sp_orders_by_dates
(
	@startdate char(12),
	@enddate char(12)
)
AS
SELECT 
orders.order_id,
orders.customer_id,
'customer_name'=customers.name,
'shipper_name'=shippers.name,
orders.shipped_date
FROM orders 
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN shippers ON orders.shipper_id = shippers.shipper_id
WHERE orders.shipped_date BETWEEN @startdate AND @enddate
GO
/*Run the stored procedure displaying orders from January 1, 2003 to June 30, 2003.*/
EXECUTE sp_orders_by_dates 'Jan 1 2003','Jun 30 2003'



/*D 3. Create a stored procedure called sp_product_listing listing a specified product ordered 
during a specified month and year. Display the product name, unit price, and quantity in stock 
from the products table, and the supplier name from the suppliers table.*/  
CREATE PROCEDURE sp_product_listing
(
	@product varchar(40),
	@month char(10),
	@year char(4)
)
AS
SELECT
'product_name'=products.name,
products.unit_price,
products.quantity_in_stock,
'supplier_name'=suppliers.name
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
INNER JOIN order_details ON products.product_id = order_details.product_id
INNER JOIN orders ON orders.order_id =order_details.order_id
WHERE products.name LIKE '%'+@product+'%'
AND
(
	DATENAME(MONTH,orders.order_date)=@month
AND DATENAME(YEAR,orders.order_date)=@year
)
GO
/*Run the stored procedure displaying a product name containing Jack and the month of 
the order date is June and the year is 2001.*/
EXECUTE sp_product_listing 'Jack','June','2001'



/*D 4. Create a DELETE trigger on the order_details table*/
CREATE TRIGGER tr_delete_quantity
ON order_details
INSTEAD OF DELETE
AS
BEGIN
SELECT
'Product_ID'=products.product_id,
'Product Name'=products.name,
'Quantity being deleted from Order'=deleted.quantity,
'In stock quantity after Deletion'=products.quantity_in_stock+deleted.quantity
FROM deleted 
INNER JOIN products ON products.product_id = deleted.product_id
END
GO
/*DELETE order_details. WHERE order_id=10001 AND product_id=25*/
DELETE order_details
WHERE order_id=10001 AND product_id=25;
GO



/*D 5. Create an INSERT and UPDATE trigger called tr_check_qty on the order_details table to only 
allow orders that have a quantity in stock greater than or equal to the units ordered.*/
CREATE TRIGGER tr_check_qty
ON order_details
FOR INSERT,UPDATE
AS
DECLARE @count int
SELECT 
@count=COUNT(inserted.order_id)
FROM inserted 
INNER JOIN products ON inserted.product_id = products.product_id
WHERE (products.quantity_in_stock >= products.units_on_order)
IF @count = 0
	BEGIN
	     PRINT 'QuantityCheck : quantity_in_stock cannot be lower than units_on_order'
	     ROLLBACK TRANSACTION
	END
ELSE
         PRINT 'Quantity have been updated'
GO
/*Run the query to verify trigger.*/
UPDATE order_details
SET quantity = 30
WHERE order_id = 10044 AND product_id = 7;
GO


/*D 6. Create a stored procedure called sp_del_inactive_cust to delete customers that have no 
orders.*/
CREATE PROCEDURE sp_del_inactive_cust
AS
DELETE customers
FROM customers
LEFT OUTER JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.customer_id IS NULL
GO
/**Run the stored procedure*/
EXECUTE sp_del_inactive_cust



/*D 7. Create a stored procedure called sp_employee_information to display the employee 
information for a particular employee. The employee id will be an input parameter*/
CREATE PROCEDURE sp_employee_information
(
     @emp_id int
)
AS
SELECT 
last_name,
first_name,
address,
city,
province,
postal_code,
'DATE OF BIRTH'=CONVERT(char(11),birth_date)
FROM employee
WHERE employee_id = @emp_id
GO
/*Run the stored procedure displaying information for employee id of 7*/
EXECUTE sp_employee_information 7



/*D 8. Create a stored procedure called sp_reorder_qty to show when the reorder level subtracted 
from the quantity in stock is less than a specified value. The unit value will be an input 
parameter for the stored procedure.*/  
CREATE PROCEDURE sp_reorder_qty
(
	@value int
)
AS
SELECT 
products.product_id,
suppliers.name,
suppliers.address,
suppliers.city,
suppliers.province,
'qty'=products.quantity_in_stock,
products.reorder_level
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE (products.quantity_in_stock-products.reorder_level)<@value
GO
/*Run the stored procedure displaying the information for a value of 5.*/
EXECUTE sp_reorder_qty 5



/*D 9. Create a stored procedure called sp_unit_prices for the product table where the unit price 
is between two particular values.*/  
CREATE PROCEDURE sp_unit_prices
(
	@value1 money,
	@value2 money
)
AS
SELECT 
product_id, 
name, 
alternate_name,
unit_price
FROM products
WHERE unit_price BETWEEN @value1 AND @value2
GO
/*Run the stored procedure to display products where the unit price is between $5.00 and $10.00.*/
EXECUTE sp_unit_prices 5.00,10.00