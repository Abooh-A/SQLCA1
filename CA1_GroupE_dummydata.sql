-- LIBRARY SQL CA1
DROP DATABASE IF EXISTS library_CA1_GroupE;
CREATE DATABASE library_CA1_GroupE;
USE library_CA1_GroupE;


-- BOOK_LOCATION TABLE (ABOOH)
CREATE TABLE BOOK_LOCATION(
	loc_id INT AUTO_INCREMENT PRIMARY KEY,
	loc_section VARCHAR(30),
	loc_floor VARCHAR(30),
	shelf VARCHAR(30)
);	
    
-- -- JULIETA -- --

-- CONDITIONS TABLE (JULIETA) --> used by Books and Devices
-- list of different conditions
CREATE TABLE CONDITIONS(
	condition_id INT AUTO_INCREMENT PRIMARY KEY,
	condition_desc VARCHAR(20)
);

-- STATUSES TABLE (JULIETA) --> used by Books and Devices
-- list of different statuses 
CREATE TABLE STATUSES(
	status_id INT AUTO_INCREMENT PRIMARY KEY,
	status_desc VARCHAR(20)
);

-- PUBLISHERS TABLE (JULIETA)
CREATE TABLE PUBLISHERS(
	publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL
);

-- AUTHORS TABLE (JULIETA)
CREATE TABLE AUTHORS(
	author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    publisher_id INT,
	FOREIGN KEY (publisher_id) REFERENCES PUBLISHERS(publisher_id)
);

-- SUPPLIERS TABLE (JULIETA)
CREATE TABLE SUPPLIERS(
	supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(50) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    address VARCHAR(255), 
    phone_no VARCHAR(20) UNIQUE,
    email VARCHAR(255) UNIQUE
);

-- LANGUAGES TABLE (JULIETA)
-- list of languages
CREATE TABLE LANGUAGES(
	language_id INT AUTO_INCREMENT PRIMARY KEY,
	language_book VARCHAR(20)
);

-- GENRE TABLE (JULIETA)
-- list of genres 
CREATE TABLE GENRES(
	genre_id INT AUTO_INCREMENT PRIMARY KEY,
	genre VARCHAR(20)
);

-- BOOKS TABLE (JULIETA)
-- all the information about a book 
CREATE TABLE BOOKS(
	isbn VARCHAR(13) PRIMARY KEY, -- ISBN are 13 digits long
    book_name VARCHAR(150) NOT NULL,
    edition VARCHAR(30),
    language_id INT,
    published_date YEAR,
    publisher_id INT,
    author_id INT NOT NULL,
    genre_id INT NOT NULL,
    FOREIGN KEY(publisher_id) REFERENCES PUBLISHERS(publisher_id),
    FOREIGN KEY(author_id) REFERENCES AUTHORS(author_id),
    FOREIGN KEY(genre_id) REFERENCES GENRES(genre_id),
    FOREIGN KEY(language_id) REFERENCES LANGUAGES(language_id) -- change the name?
);

-- BOOK_COPIES TABLE (JULIETA)
-- register of all the copies (including more than one copy of the same book)
-- here the book_id is created
CREATE TABLE BOOK_COPIES(
	book_id INT AUTO_INCREMENT PRIMARY KEY,
	isbn VARCHAR(13) NOT NULL,
    supplier_id INT, 
    cost DECIMAL,
    FOREIGN KEY(isbn) REFERENCES BOOKS(isbn),
	FOREIGN KEY(supplier_id) REFERENCES SUPPLIERS(supplier_id)
);

-- BOOKS_STATUS TABLE (JULIETA)
-- all the information about the status, conditions and locations of a book (a physical copy)   
CREATE TABLE BOOKS_STATUS(
	book_id INT PRIMARY KEY,
    status_id INT NOT NULL,
    condition_id INT NOT NULL,
    loc_id INT NOT NULL,
    FOREIGN KEY(book_id) REFERENCES BOOK_COPIES(book_id),
    FOREIGN KEY(status_id) REFERENCES STATUSES(status_id),
    FOREIGN KEY(condition_id) REFERENCES CONDITIONS(condition_id),
    FOREIGN KEY(loc_id) REFERENCES BOOK_LOCATION(loc_id)
);

-- -- END JULIETA -- ---


-- DEVICE_STATUS TABLE (EESHA)
CREATE TABLE DEVICE_STATUS (
	serial_no VARCHAR(30) PRIMARY KEY,
	status_id INT, 	
	descriptions VARCHAR(60),
	last_update DATE,
	condition_id INT,
    loc_id INT,
    
	FOREIGN KEY (loc_id) REFERENCES BOOK_LOCATION(loc_id),
    FOREIGN KEY (status_id) REFERENCES STATUSES(status_id),
    FOREIGN KEY (condition_id) REFERENCES CONDITIONS(condition_id)
);

-- DEVICES TABLE (EESHA)
CREATE TABLE DEVICES(
	serial_no VARCHAR(30) PRIMARY KEY,
	dev_name VARCHAR(30) NOT NULL,
	brand VARCHAR(30),
	cost DECIMAL(10, 2),
	warranty_end DATE NOT NULL,
	supplier_id INT,
    
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id)
); 

	-- -- ABOOH -- --

-- CUSTOMERS TABLE (ABOOH)
CREATE TABLE CUSTOMERS(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	email VARCHAR(255) UNIQUE,
	phone_no VARCHAR(30)
);

-- CUSTOMER_ADDRESSES TABLE (ABOOH)
CREATE TABLE CUSTOMER_ADDRESSES(
	customer_id INT PRIMARY KEY,
    house_apt_no INT NOT NULL,
	street VARCHAR(30),
	city VARCHAR(30),
	county VARCHAR(30),
	eircode VARCHAR(30) NOT NULL,

	FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id)
);

-- ROOMS TABLE (ABOOH)
CREATE TABLE ROOMS(
	room_no VARCHAR(30) PRIMARY KEY,
	room_name VARCHAR(30),
	floor INT
);

-- LOANS TABLE (ABOOH)
CREATE TABLE LOANS(
	loan_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	book_id INT,
	device_id VARCHAR(30),
	date_borrowed DATE,
	due_date DATE,
	return_date DATE,
    
    FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id),
	FOREIGN KEY(book_id) REFERENCES BOOK_COPIES(book_id),
	FOREIGN KEY(device_id) REFERENCES DEVICES(serial_no),

	CONSTRAINT book_xor_device CHECK ( 
	(book_id IS NOT NULL AND device_id IS NULL) OR 
	(book_id IS NULL AND device_id IS NOT NULL) )
);

-- FINES TABLE (ABOOH)
CREATE TABLE FINES(
	length_overdue INT PRIMARY KEY,
	fine_amount DECIMAL(10, 2)
);

-- WAITLIST TABLE (ABOOH)
CREATE TABLE WAITLIST(
	waitlist_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	isbn VARCHAR(30),
	request_date DATE,

	FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id),
	FOREIGN KEY(isbn) REFERENCES BOOKS(isbn)
);

-- ROOM_RESERVATIONS TABLE (ABOOH)
CREATE TABLE ROOM_RESERVATIONS(
	reservation_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	room_no VARCHAR(30),
	res_start DATE,
	res_end DATE,

	FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id),
	FOREIGN KEY(room_no) REFERENCES ROOMS(room_no)
);
	-- -- END ABOOH -- --

	-- -- EESHA -- --

-- STAFF_INFO TABLE (EESHA)
CREATE TABLE STAFF_INFO (
	staff_id INT PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	ppsn VARCHAR(30) NOT NULL,
	start_date DATE
);

-- DEPARTMENTS TABLE (EESHA)
CREATE TABLE DEPARTMENTS(
	department_id INT PRIMARY KEY,
	dep_name VARCHAR(30) NOT NULL
);

-- STAFF_HR TABLE (EESHA)
CREATE TABLE STAFF_HR (
	staff_id INT PRIMARY KEY,
	salary DECIMAL(30, 2),
	staff_role VARCHAR(30),
    department_id INT,
    
	FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id),
	FOREIGN KEY (staff_id) REFERENCES STAFF_INFO(staff_id)
);

-- CONTACTS TABLE (EESHA)
CREATE TABLE CONTACTS (
	staff_id INT PRIMARY KEY,
	email VARCHAR(255) UNIQUE NOT NULL,
	phone_no VARCHAR(30) NOT NULL,
	emergency_no VARCHAR(30),
	emergency_contact VARCHAR(30) NOT NULL,

	FOREIGN KEY (staff_id) REFERENCES STAFF_INFO(staff_id)
);

-- ADRESSES TABLE (EESHA)
CREATE TABLE ADDRESSES(
	staff_id INT PRIMARY KEY,
	eircode VARCHAR(30) NOT NULL,
	street VARCHAR(30),
	city VARCHAR(30),
	county VARCHAR(30),
	house_apt_no INT NOT NULL,

	FOREIGN KEY(staff_id) REFERENCES STAFF_INFO(staff_id)
);
-- -- END EESHA -- --
