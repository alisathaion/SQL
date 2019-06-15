/*Set the database as the current database – very important */
USE pubs


/*1.List the pub_id, pub_name, state and country columns from the publishers table where the state 
column contains null values. The query should produce the following results*/
SELECT pub_id,pub_name,state,country
FROM publishers
WHERE state IS NULL;
GO

/*2.List the distinct store ids from the sales table whose order date is Sep 14 1994. The
query should produce the result set listed below.*/
SELECT DISTINCT stor_id /*if no DISTINCT,will show repeating value*/
FROM sales
WHERE ord_date='Sep 14 1994'/*'Sep 14,1994' :will work too*/
GO

/*3.List the name, phone number and states from the authors table. Format the name of the author as 
the first name followed by a space followed by the last name. Format the phone number as left 
bracket followed by the area code followed by the right bracket followed by the phone number. 
Order the result set by the newly formatted name.*/
SELECT 
au_fname+' '+au_lname AS 'Name',/*'Name'=au_fname+' 'au_lname :It is the same */
'Phone Number'='('+SUBSTRING(phone,1,3)+') '+SUBSTRING(phone,5,8),
'STATE'=state
FROM authors
ORDER BY Name; /*ORDER BY au_fname,au_lname :will work too*/
GO

/*4.List the title id, title, advance, year to date sales, and publishing date from the titles table
where the advance is greater than or equal to $3000, and the publishing date is equal to 
June 9, 1991 or June 12, 1991. Display only the first 30 characters of the title. 
Place the comment ‘Advance is ‘ before each advance amount in the result set.*/
SELECT 
title_id,
SUBSTRING(title,1,30) AS title,
'advance'='advance is'+(CONVERT(CHAR(10),advance)),
'YTD_sales'=ytd_sales,
'pubdate'=CONVERT(CHAR(10),pubdate,105)/*format of DD-MM-YYYY*/
FROM titles
WHERE advance >= 3000 AND pubdate IN ('June 9 1991','June 12 1991')
/*advance >=3000 AND (pubdate='June 9,1991' OR pubdate='June 12,1991') :will get the same result*/
ORDER BY title;
GO

/*5. Find the average year to date sales, the minimum year to date sales, and the maximum year
to date sales from the titles table. Rename the columns with an appropriate column heading.*/
SELECT 
AVG(ytd_sales) AS 'AverageYearToDateSales',
MIN(ytd_sales) AS 'MinimunYearToDateSales',
MAX(ytd_sales) AS 'MaximunYearToDateSales'
FROM titles;
GO

/*6.List the authors with a city of Oakland, San Francisco or Berkeley, and a zip code of 94609, 
94130 or 94705. Order the result set by name.*/
SELECT 
'Authors_ID'=au_id,
'Name'=au_fname+' '+au_lname,
phone,
city,
zip
FROM authors
WHERE(city='Oakland' OR city='San Francisco' OR city='Berkeley')
AND(zip='94609' OR zip='94130' OR zip='94705')
/*WHERE city IN ('Oakland', 'San Francisco','Berkeley') AND zip IN ('94609','94130','94705') :will get the same result*/
ORDER BY Name;
GO

/*7.List the information from the roysched table where the royalty is greater than or equal to 15
and less than or equal to 20. Order the result set by the title id.*/
SELECT *
FROM roysched
WHERE (royalty >= 15) AND (royalty <= 20)/*WHERE royalty BETWEEN 15 AND 20 :will work too*/
ORDER BY title_id;
GO


/*8.List the employee id, first name, last name, job id, and hire date from the employee table for
employees with a last name beginning with the letter A or S, and a hire date greater than or
equal to January 1, 1990. Display the hire date in the format of MON DD YYYY. Order
the result set by the last name of the employee.*/
SELECT 
emp_id,
fname,
lname,
job_id,
'Hire Date'=CONVERT(char(11),hire_date)
FROM employee
WHERE (lname LIKE '[AS]%') AND (hire_date >='January 1, 1990')
/*WHERE (SUBSTRING(lname,1,1)='A' OR SUBSTRING(lname,1,1)='S') AND hire_date>='January 1,1990'*/
ORDER BY lname;


/*9.List the store id, order number, order date, and a new order date calculated by adding 10 days
to the original order date from the sales table where the quantity is less than or equal to 15.
Display the publisher date in the format of YYYY.MM.DD.*/
SELECT stor_id,ord_num,ord_date,
'NewOrderDate'=CONVERT(char(11),DATEADD(DAY,10,ord_date),102)/*Display date format YYYY.MM.DD*/
FROM sales
WHERE qty <=15;


/*10.List the employee id, first name, last name, the year of the hire date, and the number of 
years the employee has worked up to January 1, 2008 from the employee table. Format the name
as last name followed by a comma and space followed by the first name. */
SELECT 
emp_id,
lname+', '+fname AS 'Name',
'hire_date'=DATEPART(Year,hire_date),/*'hire_date'=YEAR(hire_date) :will work too*/
'Years_work'=CONVERT(char(10),DATEDIFF(YEAR,hire_date,'Jan 1 2008'))
FROM employee;


/*11. List the employee id, first name, last name, hire date, and the number of years, months and 
days the employee has worked up to January 1, 2008 from the employee table.Code assumes each month has 30 days. Format the name as last name followed by a comma and space 
followed by the first name*/
SELECT 
'Emp ID'=emp_id,
'Hire Date'=CONVERT(CHAR(11),hire_date),
'Name'=lname+', '+fname,
'Time Worked as of January 1,2008' =CONVERT(CHAR(3), DATEDIFF(YEAR,hire_date,'January 1,2008')-1)+' Years,  '
+CONVERT(CHAR(3),12-MONTH(hire_date))+'Month(s) and '
+CONVERT(CHAR(2),30-DAY(hire_date))+' day(s)'
FROM employee;