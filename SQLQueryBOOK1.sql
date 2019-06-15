USE MASTER;



If EXISTS (SELECT * FROM sysdatabases WHERE name='books1')
   DROP DATABASE books1;



CREATE DATABASE books1;



USE books1;



CREATE TYPE idtype FROM char(5) NOT NULL;



CREATE TABLE author
(
author_id idtype,
last_name varchar(30),
fist_name varchar(20),
middle_name varchar(20)
);


CREATE TABLE book
(
book_id idtype,
publisher_id idtype,
author_id idtype,
title varchar(100),
book_type char(3),
price money,
paperback varchar(1),
publish_date datetime
);



CREATE TABLE book_type
(
book_type char(3) NOT NULL,
description varchar(30)
);


CREATE TABLE branch
(
branch_id idtype,
name varchar(50),
location varchar(30),
number_emp int
);


CREATE TABLE inventory
(
book_id idtype,
branch_id idtype,
units_on_hand int
);


CREATE TABLE publisher
(
publisher_id idtype,
name varchar(40),
address varchar(30),
city varchar(20),
province char(2),
postal_code char(6)
);


ALTER TABLE author
ADD PRIMARY KEY(author_id);

ALTER TABLE book
ADD PRIMARY KEY(book_id);

ALTER TABLE book_type
ADD PRIMARY KEY(book_type);

ALTER TABLE branch
ADD PRIMARY KEY(branch_id);

ALTER TABLE inventory
ADD PRIMARY KEY(book_id,branch_id);

ALTER TABLE publisher
ADD PRIMARY KEY(publisher_id);

ALTER TABLE book
ADD CONSTRAINT fk_book_publisher FOREIGN KEY(publisher_id) 
REFERENCES publisher(publisher_id);

ALTER TABLE book
ADD CONSTRAINT fk_book_author FOREIGN KEY(author_id) 
REFERENCES author(author_id);

ALTER TABLE book
ADD CONSTRAINT fk_book_book_tye FOREIGN KEY(book_type)
REFERENCES book_type(book_type);

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_book FOREIGN KEY(book_id)
REFERENCES book(book_id);

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_branch FOREIGN KEY(branch_id)
REFERENCES branch(branch_id);

ALTER TABLE publisher
ADD CONSTRAINT default_province
DEFAULT('BC') FOR province;

ALTER TABLE book
ADD CONSTRAINT default_paperback
DEFAULT('N') FOR paperback;