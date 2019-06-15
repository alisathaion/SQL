USE pubs;

/*1.Using subqueries, write a query to display the first name, last name, address, city and state 
for the authors who live in the state of CA, and who have at least one book type of popular_comp. 
Display the name of the author as last name followed by a comma and a space followed 
by the first name.*/
SELECT
'Name'=au_lname+', '+au_fname,
'Adddress'=address,
'State'=state,
'City'=city
FROM authors
WHERE au_id IN
     (SELECT au_id
      FROM titleauthor
      WHERE title_id IN
	        (SELECT title_id
			 FROM titles
			 WHERE state='CA' AND type='popular_comp'))
ORDER BY Name;/*ORDER BY au_lname,authors.au_fname :will work too*/


/*2.same as question 1, but uses INNER JOIN*/
SELECT
'Name'=authors.au_lname+', '+authors.au_fname,
'Address'=authors.address,
'State'=authors.state,
'City'=authors.city
FROM authors
INNER JOIN titleauthor ON authors.au_id=titleauthor.au_id
INNER JOIN titles ON titleauthor.title_id=titles.title_id
WHERE titles.type='popular_comp' AND authors.state='CA'
ORDER BY Name;


/*Create a view called vw_sales_title_info to display the store id, order date and quantity from
the sales table, the store name from the stores table, and the title, price, advance and publish
date from the titles table*/
CREATE VIEW vw_sales_title_info
(Store_ID,Orde_rDate,Quantity,Store_Name,Title,Price,Advance,Publish)/*can skip define column name*/
AS
SELECT
sales.stor_id,
sales.ord_date,
sales.qty,
stores.stor_name,
titles.title,
titles.price,
titles.advance,
titles.pubdate
FROM sales
INNER JOIN stores ON sales.stor_id=stores.stor_id
INNER JOIN titles ON titles.title_id=sales.title_id;

/*to drop view*/
DROP VIEW vw_sales_title_info;


/*Run the view vw_sales_title_info displaying the store id, store name, title, and price where
the price is equal to $19.99. Order the result set by the store id*/
SELECT 
Store_ID,
Store_Name,
Title,
Price
FROM vw_sales_title_info
WHERE Price=19.99
ORDER BY Store_ID;

/*5.Create a view called vw_insert_stores to display the store id, store name and state from the
Stores table*/
CREATE VIEW vw_insert_stores
AS
SELECT
stor_id,
stor_name,
state
FROM stores;

/*to drop view*/
DROP VIEW vw_insert_stores;

/*6.Using the view vw_insert_stores, insert a row in the stores table with a store id of 9999, a
Store name of Peterson’s Book, and a state of UT*/
INSERT INTO vw_insert_stores
VALUES('9999','Peterson’s Book','UT')

/*to delete*/
DELETE FROM vw_insert_stores
WHERE stor_id = '9999';

/*to run view*/
SELECT *
FROM vw_insert_stores;

/*7.List the employee id, first name, middle initial, last name from the employee table, and the
job id and job description from the job table for employees with a job id of 10, 12, or 14. The
name of the employee should be formatted as the first letter of the first name followed by a
period and a space followed by the middle initial followed by period and space followed by
the last name. If the middle initial is a space, display the first name and last name only*/
SELECT 
employee.emp_id,
/*'Name'=REPlACE(SUBSTRING(employee.fname,1,1)+'. '+REPLACE(employee.minit,' ','.')+'. '+employee.lname,'. ..','.'),*/
REPLACE(SUBSTRING(employee.fname,1,1)+'. '+employee.minit+'. '+employee.lname,' . ','') as Name,
jobs.job_desc
FROM employee
INNER JOIN jobs ON employee.job_id=jobs.job_id
WHERE jobs.job_id IN (10,12,14)
ORDER BY employee.fname;


/*8.Using a subquery, list the publisher id and name of the publishers who have published business
books.(Hint: Use the EXISTS command.)*/
SELECT 
pub_id,
pub_name
FROM publishers
WHERE EXISTS
    ( SELECT type
      FROM titles
      WHERE publishers.pub_id=titles.pub_id AND titles.type='business');



/*9. Write the command to determine the index for the employee table*/
SP_HELPINDEX employee;


/*10.Write the command to create a new composite index called empinx on the employee table for
the columns emp_id, hire_date.*/
CREATE INDEX empinx
ON employee(emp_id,hire_date);