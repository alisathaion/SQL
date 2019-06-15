USE pubs;


/*1ist the first and the last name of the employee with a name of Thomas. Use local variables for 
the first name and the last name and the @@ROWCOUNT command. Display the first name and the last 
name if the name is found, and the message “Employee not found” if the last name does not exist in
the employee table*/
DECLARE @fname char(20),
        @lname char(20)

SELECT @fname=fname,@lname=lname
FROM employee
WHERE lname='Thomas'

IF @@ROWCOUNT>0
     PRINT 'Employee Name is '+RTRIM(@fname)+' '+@lname
ELSE 
     PRINT 'Employee not found'
GO

/* The select line associates the required table columns to the created local variables */
/*ALTERNATIVE WAY FOR SAME RESULT
IF @@ROWCOUNT=0
   PRINT 'Employee not found'
ELSE
   SELECT
   /* A space heading is assigned to remove the heading display */
   ' '='Employee Name is '+RTRIM(@vfname)+' '+@vlname
*/



/*2ist the employees with a hire date between January 1 1989 and December 31 1990.Display the 
employee id, first name, last name, hire date and job id from the employee table, and the job 
description from the job table. Use local variables for the two hire dates. Display the name of 
the employee as the last name followed by a comma and a space followed by the first name. Also, 
display the hire date as MMM DD YYYY*/
DECLARE @hiredate1 DATETIME, @hiredate2 DATETIME
SET @hiredate1='Jan 1 1989'
SET @hiredate2='Dec 31 1990'

SELECT 
employee.emp_id,
'Name'=employee.lname+', '+employee.fname,
'hire_date'=CONVERT(char(11),employee.hire_date,100),
employee.job_id,
jobs.job_desc
FROM employee
INNER JOIN jobs ON employee.job_id = jobs.job_id
WHERE hire_date BETWEEN @hiredate1 AND @hiredate2
ORDER BY employee.lname;




/*3Create a stored procedure called author_information which takes two input parameters of 
an author id and a title id, and returns three output parameters of the last name, the first name,
and the royalty percentage.*/
CREATE PROCEDURE author_information
(
@authorId varchar(11),
@titleId varchar(6),
@lname varchar(40) OUTPUT,
@fname varchar(20) OUTPUT,
@royalty int OUTPUT
)
AS
SELECT 
@lname=authors.au_lname,
@fname=authors.au_fname,
@royalty=titleauthor.royaltyper
FROM authors 
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
WHERE authors.au_id = @authorId AND titleauthor.title_id = @titleId
GO

/*Delete procedure*/
DROP PROCEDURE author_information



/*Run the stored procedure author_information for a value of 672-71-3249 for the author id and 
a value of TC7777 for the title id. 
Display the output values from the stored procedure for the first name, the last name, 
and the royalty percentage.*/
DECLARE @dis_lname varchar(40),
        @dis_fname varchar(20),
        @dis_royalty int

EXECUTE author_information 
'672-71-3249',
'TC7777',
@dis_lname OUTPUT,
@dis_fname OUTPUT,
@dis_royalty OUTPUT

PRINT 'Author: '+@dis_lname+' '+@dis_fname
PRINT 'Royalty Percentage = '+CONVERT(char(5),@dis_royalty)
/*Alternative way for print
SELECT ' '='Author: '+@dis_lname+' '+@dis_fname
SELECT ' '='Royalty percentage is '  +CONVERT(CHAR(10),@dis_royalty)
*/

/*Create an INSERT trigger on the sales table called tr_insert_ytd to update the ytd_sales column 
in the titles table by adding the quantity inserted in the sales table to the ytd_sales column 
in the titles table.*/

CREATE TRIGGER tr_insert_ytd
ON	sales 
FOR INSERT
AS
/* CREATE 2 variables to store values from the inserted table and store them */
DECLARE @QTY SMALLINT, @ID VARCHAR(6)

SELECT @QTY=qty FROM inserted 
SELECT @ID=title_id FROM inserted

/* do the update on the titles table */
UPDATE TITLES 
SET ytd_sales=ytd_sales+@QTY
WHERE title_id=@ID
GO

/*To test trigger*/
SELECT ytd_sales 
FROM titles WHERE title_id='PS7777';

INSERT INTO SALES 
VALUES('7131',26777,'2011-03-15',5,'NET 30','PS7777');









