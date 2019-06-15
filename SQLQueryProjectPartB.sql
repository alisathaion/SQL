USE Cus_Orders;
GO



/*B 1. List the customer id, name, city, and country from the customer table. 
Order the result set by the customer id. */
SELECT customer_id, name, city, country
FROM customers
ORDER BY customer_id;
GO



/*B 2. Add a new column called active to the customers table. The only valid values 
are 1 or 0.  The default should be 1. */
ALTER TABLE customers
ADD active bit DEFAULT(1) NOT NULL;
GO



/*B 3. List order id, order date, and a new shipped date from the orders table, 
the product name from the product table, the customer name from the customer table, 
and the cost of the order where the order date is sometime in January or February 2004*/
SELECT 
orders.order_id,
products.name,
customers.name,
'order_date'=CONVERT(char(11),orders.order_date),
'new_shippped_date'=CONVERT(char(11),DATEADD(DAY,7,shipped_date)),
'order_cost'= products.unit_price*order_details.quantity
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN order_details ON order_details.order_id = orders.order_id
INNER JOIN products ON products.product_id = order_details.product_id
WHERE
    (
    DATENAME(MONTH,orders.order_date)='January' AND DATENAME(YEAR,orders.order_date)='2004'
    ) 
    OR
    (
    DATENAME(MONTH,orders.order_date)='February' AND DATENAME(YEAR,orders.order_date)='2004'
    );
GO



/*B 4. List the customer id, name and phone number from the customers table, 
and the order id and order date from the orders table. Where the orders that have not been 
shipped. Order the result set by the order date  */
SELECT
'Cus_ID'=customers.customer_id,
'Cus_Name'=customers.name,
'Cus_Phone'=customers.phone,
'Order_No'=orders.order_id,
'Order Date'=CONVERT(char(11),orders.order_date)
FROM customers 
INNER JOIN orders 
ON customers.customer_id = orders.customer_id
WHERE orders.shipped_date IS NULL
ORDER BY orders.order_date;
GO



/*B 5.List the customer id, name, and city from the customers table, and the title- 
description from the titles table. Where the region is NULL*/
SELECT
customers.customer_id,
customers.name,
customers.city,
titles.description
FROM customers
INNER JOIN titles ON customers.title_id = titles.title_id
WHERE customers.region IS NULL;
GO



/*B 6.List supplier name from the suppliers table, the product name, reorder level, 
and quantity in stock from the products table. Where the reorder level is higher than 
the quantity in stock. Order the result set by the supplier name */
SELECT 
'supplier_name'=suppliers.name,
'product_name'=products.name,
products.reorder_level,
products.quantity_in_stock
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id
WHERE products.reorder_level > products.quantity_in_stock
ORDER BY suppliers.name;
GO



/*B 7. List the order id, and the shipped date from the orders table, the customer name, 
and the contact name from the customers table, and the length in year. where shipped date is 
NOT NULL. Order BY order ID and length in year*/
SELECT
orders.order_id,
customers.name,
customers.contact_name,
'shipped_date'=CONVERT(char(11),orders.shipped_date),
'elapsed'=DATEDIFF(YEAR,orders.shipped_date,'Jan1 2008')
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NOT NULL
ORDER BY orders.order_id,elapsed
GO



/*B 8. List number of customers with names beginning with each letter of the alphabet. 
Not including name begins with the letter F or G. Do not count or display unless at least 
six customer’s names begin with the letter*/
SELECT
'First letter of Customer''s Name'= UPPER(SUBSTRING(name,1,1)),
'Total Count'=COUNT(*)
FROM customers
WHERE (name NOT LIKE 'F%' AND name NOT like 'G%')
GROUP BY UPPER(SUBSTRING(name,1,1))
HAVING COUNT(*) >= 6;
GO



/*B 9. List the order id and quantity from the order_details table, the product id and reorder 
level from the products table, and the supplier id from the suppliers table*/
 SELECT
 order_details.order_id,
 order_details.quantity,
 products.product_id,
 products.reorder_level,
 suppliers.supplier_id
 FROM order_details
 INNER JOIN products ON order_details.product_id = products.product_id
 INNER JOIN suppliers ON suppliers.supplier_id = products.supplier_id
 WHERE order_details.quantity > 100
 ORDER BY order_details.order_id;
 GO



 /*B 10. List the product id, product name, quantity per unit and unit price from the products 
 table. Where the product name contains tofu or chef. Order the result set by product name*/
 SELECT
 product_id,
 name,
 quantity_per_unit,
 unit_price
 FROM products
 WHERE (name LIKE '%tofu%' OR name LIKE '%chef%')
 ORDER BY name;
 GO