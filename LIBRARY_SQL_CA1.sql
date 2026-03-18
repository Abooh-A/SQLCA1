-- LIBRARY SQL CA1
DROP DATABASE IF EXISTS library_CA1;
CREATE DATABASE library_CA1;
USE library_CA1;
	-- JULIETTA

-- CONDITIONS TABLE
-- BOOKS_STATUS TABLE
-- BOOK_COPIES TABLE
-- BOOKS TABLE
-- AUTHORS TABLE
-- PUBLISHERS TABLE
-- SUPPLIERS TABLE

	-- ABOOH

-- LOANS TABLE
CREATE TABLE LOANS(
	loan_id INT PRIMARY KEY,
	customer_id VARCHAR(30),
	book_id VARCHAR(30),
	device_id VARCHAR(30),
	date_borrowed DATE,
	due_date DATE,
	return_date DATE
    
-- FK refrences to be added
    customer_id
	book_id
	device_id
);

-- FINES TABLE
CREATE TABLE FINES(
	length_overdue INT PRIMARY KEY,
	fine_amount DECIMAL(10, 2)
);

-- WAITLIST TABLE
CREATE TABLE WAITLIST(
	waitlist_id INT PRIMARY KEY,
	customer_id INT,
	item_id INT,
	request_date DATE

	-- FK refrences to be added
	customer_id
	item_id
);

-- ROOM_RESERVATIONS TABLE
CREATE TABLE ROOM_RESERVATIONS(
	reservation_id INT PRIMARY KEY,
	customer_id INT,
	room_no VARCHAR(30),
	res_start DATE,
	res_end DATE

	-- FK refrences to be added
	customer_id
	room_no
);

-- ROOMS TABLE
CREATE TABLE ROOMS(
	room_no VARCHAR(30) PRIMARY KEY,
	name VARCHAR(30),
	floor INT
);

-- CUSTOMERS TABLE
CREATE TABLE CUSTOMERS(
	customer_id VARCHAR(30) PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	email VARCHAR(30),
	phone_no VARCHAR(30),
	address VARCHAR(30)
);

-- BOOK_LOCATION TABLE
CREATE TABLE BOOK_LOCATION(
	loc_id VARCHAR(30) PRIMARY KEY,
	section VARCHAR(30), -- field name will need to be changed
	floor VARCHAR(30),
	shelf VARCHAR(30),
);

	-- EESHA

-- STAFF_INFO TABLE
-- STAFF_HR TABLE
-- CONTACTS TABLE
CREATE TABLE ADDRESSES(
	
);
CREATE TABLE DEPARTMENTS(
	
);
-- DEVICE_STATUS TABLE
CREATE TABLE DEVICES(
	
); 
