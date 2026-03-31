-- LIBRARY SQL CA1
DROP DATABASE IF EXISTS library_CA1;
CREATE DATABASE library_CA1;
USE library_CA1;

-- BOOK_LOCATION TABLE (ABOOH)
CREATE TABLE BOOK_LOCATION(
	loc_id VARCHAR(30) PRIMARY KEY,
	loc_section VARCHAR(30),
	loc_floor VARCHAR(30),
	shelf VARCHAR(30)
);
	-- JULIETA

-- CONDITIONS TABLE
-- BOOKS_STATUS TABLE
-- BOOK_COPIES TABLE
-- BOOKS TABLE
CREATE TABLE BOOKS(
	isbn VARCHAR(13) PRIMARY KEY, -- ISBN are 13 digits long
    book_name VARCHAR(150) NOT NULL,
    edition VARCHAR(30),
    book_language VARCHAR(30),
    published_date DATE,
    publisher_id INT,
    author_id INT,
    genre VARCHAR(30),
    FOREIGN KEY(publisher_id) REFERENCES Publishers(publisher_id),
    FOREIGN KEY(author_id) REFERENCES Authors(author_id)
);



-- AUTHORS TABLE
-- PUBLISHERS TABLE
-- SUPPLIERS TABLE
-- LANGUAGES TABLE
-- GENRE TABLE

-- DEVICE_STATUS TABLE (EESHA)
CREATE TABLE DEVICE_STATUS (
	serial_no VARCHAR(30) PRIMARY KEY,
	status VARCHAR(30), -- ask what this is about and if i can use enum
	description VARCHAR(30),
	last_update DATE,
	condition VARCHAR(30),
	loc_id VARCHAR(30); -- FK
);

	-- ABOOH

-- CUSTOMERS TABLE
CREATE TABLE CUSTOMERS(
	customer_id INT PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	email VARCHAR(30),
	phone_no VARCHAR(30),
	address VARCHAR(30)
);

-- ROOMS TABLE
CREATE TABLE ROOMS(
	room_no VARCHAR(30) PRIMARY KEY,
	room_name VARCHAR(30),
	floor INT
);

-- LOANS TABLE
CREATE TABLE LOANS(
	loan_id INT PRIMARY KEY,
	customer_id INT,
	book_id VARCHAR(30),
	device_id VARCHAR(30),
	date_borrowed DATE,
	due_date DATE,
	return_date DATE,
    
    Foreign key(customer_id) references CUSTOMERS(customer_id),

-- FK refrences to be added external
	-- FOREIGN KEY(book_id) REFERENCES BOOK_COPIES(book_id)
	-- FOREIGN KEY(device_id) REFERENCES DEVICES(device_id)

	CONSTRAINT book_xor_device CHECK ( 
	(book_id IS NOT NULL AND device_id IS NULL) OR 
	(book_id IS NULL AND device_id IS NOT NULL) )
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
	isbn VARCHAR(30),
	request_date DATE,

	Foreign key(customer_id) references CUSTOMERS(customer_id),

-- FK refrences to be added external
	-- FOREIGN KEY(isbn) REFERENCES BOOKS(isbn)
);

-- ROOM_RESERVATIONS TABLE
CREATE TABLE ROOM_RESERVATIONS(
	reservation_id INT PRIMARY KEY,
	customer_id INT,
	room_no VARCHAR(30),
	res_start DATE,
	res_end DATE,

	Foreign key(customer_id) references CUSTOMERS(customer_id),
	Foreign key(room_no) references ROOMS(room_no)
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

--DEPARTMENTS TABLE
CREATE TABLE DEPARTMENTS(
	department_id VARCHAR(30) PRIMARY KEY,
	name VARCHAR(30) NOT NULL;
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

--DEVICES TABLE
CREATE TABLE DEVICES(
	serial_no VARCHAR(30) PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	brand VARCHAR(30),
	cost DECIMAL(10, 2) NOT NULL,
	warranty_end DATE NOT NULL,
	supplier_id INT(30);
); 
