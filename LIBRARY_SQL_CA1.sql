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
	return_date DATE,
    
    Foreign key(customer_id) references CUSTOMERS(customer_id)

-- external FK refrences to be added
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
	request_date DATE,

	Foreign key(customer_id) references CUSTOMERS(customer_id),
	Foreign key(isbn) references BOOKS(isbn)
);

-- ROOM_RESERVATIONS TABLE
CREATE TABLE ROOM_RESERVATIONS(
	reservation_id INT PRIMARY KEY,
	customer_id INT,
	room_no VARCHAR(30),
	res_start DATE,
	res_end DATE

	Foreign key(customer_id) references CUSTOMERS(customer_id),
	Foreign key(room_no) references ROOMS(room_no)
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
CREATE TABLE STAFF_INFO (
	staff_id INT(30) PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	ppsn VARCHAR(30) NOT NULL,
	start_date DATE;
);

-- STAFF_HR TABLE
CREATE TABLE STAFF_HR (
	staff_id INT(30) PRIMARY KEY,
	salary DECIMAL(30, 2),
	role VARCHAR(30),
	department_id VARCHAR(30); -- FK
);

--ADRESSES TABLE
CREATE TABLE CONTACTS (
	staff_id INT(30) PRIMARY KEY,
	email VARCHAR(30) NOT NULL,
	phone_no VARCHAR(30) NOT NULL,
	emergency_no VARCHAR(30),
	emergency_contact VARCHAR(30) NOT NULL;
);

-- ADRESSES TABLE
CREATE TABLE ADDRESSES(
	staff_id INT(30) PRIMARY KEY,
	eircode VARCHAR(30) NOT NULL,
	street VARCHAR(30),
	city VARCHAR(30),
	county VARCHAR(30),
	house_apt_no INT(30) NOT NULL;
);

--DEPARTMENTS TABLE
CREATE TABLE DEPARTMENTS(
	department_id VARCHAR(30) PRIMARY KEY,
	name VARCHAR(30) NOT NULL;
);

--DEVICE_STATUS TABLE
CREATE TABLE DEVICE_STATUS (
	serial_no VARCHAR(30) PRIMARY KEY,
	status VARCHAR(30), -- ask what this is about and if i can use enum
	description VARCHAR(30),
	last_update DATE,
	condition VARCHAR(30),
	loc_id VARCHAR(30); -- FK
);

--DEVICES TABLE
CREATE TABLE DEVICES(
	serial_no VARCHAR(30) PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	brand VARCHAR(30),
	cost DECIMAL(10, 2) NOT NULL,
	warranty_end DATE NOT NULL,
	supplier_id INT(30);
); 
