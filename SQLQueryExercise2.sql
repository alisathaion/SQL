USE pubs;


/*1.INSERT:Using the INSERT command, add a new title to the titles table with a title id of ZZ1234, 
title of Microsoft SQL Server, type of computer, publisher id of 0877, price of $89.99, 
and a publish date of  September 29, 2008.  (Hint: Depending on the data type involved, 
you will need to put single quotes around some input values)*/
INSERT INTO titles(title_id,title,type,pub_id,price,pubdate)/*can not insert column with IDENTITY*/
VALUES('ZZ1234','Microsoft SQL Server','computer','0877',89.99,'September 29,2008');

/*2.UPDATE:Using the UPDATE command,increase the price by 10% for the title created in question 1*/
UPDATE titles
SET price=price*1.1
WHERE title_id='ZZ1234';

/*3.DELETE:Delete the title created in question 1 and updated in question 2*/
delete from titles
where title_id='ZZ1234';


/*4.CREATE A NEW TABLE:Create a new table called business_books containing the following columns:
title_id,title,price,pub_id and pubdate all of which should be taken from the titles table. 
The new table should contain only records (from the titles table) which have a type of ‘business’.
(There should be 4 rows affected – in other words 4 rows should be copied from the titles table to
your new table).*/
SELECT title_id,title,price,pub_id,pubdate
INTO business_book
FROM titles
WHERE type= 'business';

/*5.INNER JOIN:Write and execute a query which will show, for each title sold, the title, 
title type, publisher to whom the title was sold, the order date, order number, quantity sold, 
unit price and the total cost (price* qty). Order the results by title. 
(Hint: 3 tables are involved – titles, sales and publishers)*/
SELECT 
'Title'=titles.title,
'Type'=titles.type,
'Publisher Name'=publishers.pub_name,
'Order Date'=sales.ord_date,
'Order Number'=sales.ord_num,
'Quantity'=sales.qty,
'Price'=titles.price,
'Total Cost'=titles.price*sales.qty
FROM titles
INNER JOIN sales ON titles.title_id=sales.title_id
INNER JOIN publishers ON publishers.pub_id=titles.pub_id
ORDER BY titles.title;


/*6.LEFT OUTER JOINS:Write and execute a query which will show, for every title (from the titles 
table), all orders (from the sales table) that have been placed  by stores (from the stores table)
with orders registered for each title.
Required columns:  the title from the titles table, the order number and order date from the sales
table, and the store name from the stores table. Order the result set by order number.*/
SELECT 
'Title'=LEFT(titles.title,30),/*'Title'=SUBSTRING(titles.title,1,30)*/
'Order Number'=sales.ord_num,
'Order Date'=CONVERT(char(12),sales.ord_date),/*convert(char(12),sales.ord_date,107) : with comma*/
'Store Name'=stores.stor_name
FROM titles 
LEFT OUTER JOIN sales ON titles.title_id=sales.title_id
LEFT OUTER JOIN stores ON sales.stor_id=stores.stor_id
ORDER BY sales.ord_num;


/*7.GRUOP BY:For each Type/ Publisher group combination, list the total number of books ordered 
(this refers to the qty column from the sales table) and Minimum Price (from the titles table). 
(Hint: 3 tables are involved. You will need to use an inner join and also GROUP BY)*/
SELECT
'Type'=titles.type,
'Publisher Name'=publishers.pub_name,
'Quantity'=SUM(sales.qty),
'Min Price'=MIN(titles.price)
FROM titles
INNER JOIN publishers ON titles.pub_id=publishers.pub_id
INNER JOIN sales ON sales.title_id=titles.title_id
GROUP BY publishers.pub_name,titles.type;


/*8.INNER JOINS + WHERE:A query is required which will return the results set shown below. 
The objective is to list orders from stores showing: the Order number, Store Name, Store Number, 
Title Ordered, Quantity Ordered, Price and the Order Cost for each title (Derived by multiplying 
the Price by the quantity ordered by a given store). Additionally, only records for order costs 
between $150.00 and $500.00 are required. 
(Hints: 3 tables are involved: titles, stores and sales. 2 Inner Joins are needed)*/
SELECT
'Order Number'=sales.ord_num,
'Store ID'=stores.stor_id,
'Store Name'=stores.stor_name,
'Quantity'=sales.qty,
'Price'=titles.price,
'Order Cost'=(sales.qty*titles.price)
FROM sales
INNER JOIN titles ON sales.title_id=titles.title_id
INNER JOIN stores ON sales.stor_id=stores.stor_id
WHERE (sales.qty*titles.price) BETWEEN 150 AND 500;
/*(sales.qty*titles.price)>=15 AND (sales.qty*titles.price)<=500*/


/*9.UNIONS:Using the UNION command, calculate new prices for the books bases on the year-to-date
sales for each book in the titles table.If the year-to-date sales are less than $2500, add 15% to 
the price; if the year-to-date sales are greater than or equal to $2500 and less than or equal to 
$10000, add 10% to the price of the book; if the year-to-date sales are greater than $10000, 
add 5% to the price.Display the title id, year-to-date sales, price and the new calculated price 
from the titles table.Order the result set by title id.  
(Hints:3 statements and 2 UNIONs are required.The order is set at the end of the last statement)*/
SELECT
'Title ID'=title_id,
'YTD sale'=ytd_sales,
'Original Price'=price,
'New Price'=price+(price*0.15)
FROM titles
WHERE price<2500
UNION
SELECT
'Title ID'=title_id,
'YTD sale'=ytd_sales,
'Original Price'=price,
'New Price'=price+(price*0.1)
FROM titles
WHERE (price>=2500) AND (price<=10000)
UNION
SELECT
'Title ID'=title_id,
'YTD sale'=ytd_sales,
'Original Price'=price,
'New Price'=price+(price*0.05)
FROM titles
WHERE price>10000
ORDER BY title_id;


/*10.ROLLUP:From the titles table, list the type, Average Price and Sum of all prices by type, 
with overall aggregate results for all types not UNDECIDED types.*/
SELECT
'Type'=type,
'Average Price'=AVG(price),
'Total Price'=SUM(price)
FROM titles
WHERE type!='UNDECIDED'/*WHERE type <>'UNDECIDED'*/
GROUP BY
ROLLUP(type)/*GROUP BY without ROLLUP will not show total of column AVG and SUM
