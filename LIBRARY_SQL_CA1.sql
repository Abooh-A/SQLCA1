-- LIBRARY SQL CA1
DROP DATABASE IF EXISTS library_CA1_GroupE;
CREATE DATABASE library_CA1_GroupE;
USE library_CA1_GroupE;

/* ----------------------------------------------------------
					CREATING TABLES 
 ---------------------------------------------------------- */
 

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

-- ROOMS TABLE (ABOOH)
CREATE TABLE ROOMS(
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(30),
    floor INT
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

-- DEVICE_STATUS TABLE (EESHA)
CREATE TABLE DEVICE_STATUS (
	serial_no VARCHAR(30) PRIMARY KEY,
	status_id INT, 	
	descriptions VARCHAR(60),
	last_update DATE,
	condition_id INT,
    room_id INT,
    
    FOREIGN KEY (serial_no) REFERENCES DEVICES(serial_no),
	FOREIGN KEY (room_id) REFERENCES ROOMS(room_id), 
    FOREIGN KEY (status_id) REFERENCES STATUSES(status_id),
    FOREIGN KEY (condition_id) REFERENCES CONDITIONS(condition_id)
    
);

	-- -- ABOOH -- --

-- CUSTOMERS TABLE (ABOOH)
CREATE TABLE CUSTOMERS(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	email VARCHAR(255) UNIQUE,
	phone_no VARCHAR(30) UNIQUE
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
	isbn VARCHAR(13),
	request_date DATE,

	FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id),
	FOREIGN KEY(isbn) REFERENCES BOOKS(isbn)
);

-- ROOM_RESERVATIONS TABLE (ABOOH)
CREATE TABLE ROOM_RESERVATIONS(
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    room_id INT,
    res_start DATE,
    res_end DATE,

    FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id),
    FOREIGN KEY(room_id) REFERENCES ROOMS(room_id)
);
	-- -- END ABOOH -- --

	-- -- EESHA -- --

-- STAFF_INFO TABLE (EESHA)
CREATE TABLE STAFF_INFO (
	staff_id INT PRIMARY KEY,
	f_name VARCHAR(30) NOT NULL,
	l_name VARCHAR(30) NOT NULL,
	ppsn VARCHAR(30) NOT NULL,
    date_of_birth DATE,
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
	phone_no VARCHAR(30) UNIQUE NOT NULL,
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



/* ----------------------------------------------------------
						QUERIES
 ---------------------------------------------------------- */
 
 
-- ABOOH QUERIES
/* -------------------------------------------------------------------------
	ABOOH QUERY 1: Bad Borrowers
	Customers with total built up fines over €20, flagged against waitlist
    entries and room reservations for removal. But still showing those with 
    large fine amounts even if not on waitlist.
   ------------------------------------------------------------------------- */
SELECT
    C.customer_id,
    C.f_name,
    C.l_name,
    SUM(F.fine_amount) AS total_fines,
    COUNT(DISTINCT W.waitlist_id) AS active_waitlist_entries,
    COUNT(DISTINCT R.reservation_id) AS active_reservations
FROM CUSTOMERS C
JOIN LOANS L ON C.customer_id = L.customer_id
JOIN FINES F ON DATEDIFF(IF(L.return_date IS NULL, CURDATE(), L.return_date), L.due_date) = F.length_overdue
LEFT JOIN WAITLIST W ON C.customer_id = W.customer_id
LEFT JOIN ROOM_RESERVATIONS R ON C.customer_id = R.customer_id
WHERE DATEDIFF(IF(L.return_date IS NULL, CURDATE(), L.return_date), L.due_date) > 0
GROUP BY C.customer_id, C.f_name, C.l_name
HAVING SUM(F.fine_amount) > 20
ORDER BY total_fines DESC;


/* -------------------------------------------------------------------------
	ABOOH QUERY 2: Device Warranty Alert
	Devices that need to be checked for damage then filters those that are 
    currently on loan that need to be looked over for any damage grouped by
    urgency based on days remaining between due date and warranty expiry
  -------------------------------------------------------------------------*/
SELECT
    D.serial_no,
    D.dev_name,
    D.brand,
    D.warranty_end,
    DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) AS days_until_warranty_expires,
    CASE
        WHEN DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) BETWEEN 0 AND 5   THEN 'CRITICAL (0-5 days)'
        WHEN DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) BETWEEN 6 AND 10  THEN 'HIGH (6-10 days)'
        WHEN DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) BETWEEN 11 AND 20 THEN 'MEDIUM (11-20 days)'
        WHEN DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) BETWEEN 21 AND 30 THEN 'LOW (21-30 days)'
    END AS urgency_band,
    CASE WHEN L.return_date IS NULL THEN 'Out on Loan' ELSE 'Available' END AS loan_status,
    MAX(L.date_borrowed) AS last_borrowed
FROM DEVICES D
LEFT JOIN LOANS L ON D.serial_no = L.device_id
WHERE DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) BETWEEN 0 AND 30
GROUP BY D.serial_no, D.dev_name, D.brand, D.warranty_end, days_until_warranty_expires, urgency_band, loan_status
ORDER BY days_until_warranty_expires ASC;


/* -------------------------------------------------------------------------
	ABOOH QUERY 3: Peak Demand Days
	Loans and room reservations grouped by day of the week to identify
	the busiest days of the year and a total how many customers per day 
    througout the year for staffing decisions
   ------------------------------------------------------------------------- */
SELECT
    day_of_week,
    COUNT(*) AS total_events,
    COUNT(DISTINCT customer_id) AS customers_per_day
FROM (
    SELECT
        DAYNAME(L.date_borrowed) AS day_of_week,
		C.customer_id
    FROM LOANS L
    JOIN CUSTOMERS C ON C.customer_id = L.customer_id
    WHERE YEAR(L.date_borrowed) = YEAR(CURDATE())

    UNION ALL

    SELECT
        DAYNAME(RR.res_start) AS day_of_week,
        C.customer_id
    FROM ROOM_RESERVATIONS RR
    JOIN CUSTOMERS C ON C.customer_id = RR.customer_id
    WHERE YEAR(RR.res_start) = YEAR(CURDATE())
) AS combined_events
GROUP BY day_of_week
ORDER BY total_events DESC;


/* -------------------------------------------------------------------------
	ABOOH QUERY 4: Bad Condition Device Assignment
	Retrieves all devices in bad condition alongside their current room 
	location and status, then assigns the newest IT Support staff member 
	as the responsible person for inspection and repair
  -------------------------------------------------------------------------*/
SELECT 
	DS.serial_no,
    D.dev_name,
    S.status_desc,
	DS.descriptions,
	C.condition_desc,
	R.room_name,
    assigned_staff.assigned_staff
FROM DEVICE_STATUS ds
JOIN STATUSES s on ds.status_id = s.status_id
JOIN ROOMS R on DS.room_id = R.room_id
JOIN DEVICES D on D.serial_no = DS.serial_no
JOIN CONDITIONS C on C.condition_id = DS.condition_id
CROSS JOIN (SELECT 
		    CONCAT(SI.f_name, ' ', SI.l_name) AS assigned_staff
			FROM STAFF_INFO SI
			JOIN STAFF_HR SH ON SH.staff_id = SI.staff_id
			WHERE SH.staff_role = 'IT Support'
			ORDER BY SI.start_date DESC
			LIMIT 1) AS assigned_staff
WHERE DS.condition_id = 4 OR DS.condition_id = 5;
 
 
-- JULIETA QUERIES
/* -------------------------------------------------------------------------
	JULIETA 1st QUERY: REPARATION NEEDED 
	- List of the books that need reparation, with the book id, status and location. Name of the book.  
	- If the book is not at the library, add the due date when they are going to be return.  
	------------------------------------------------------------------------- */

SELECT bs.book_id AS BookID,
c.condition_desc AS Book_Condition,
b.book_name AS Book,
s.status_desc AS Book_Status,
l.loan_id AS LoanID, -- To have the ID at hand in case needed to check or be modified
l.due_date AS Due_Date,

CASE 
	WHEN l.loan_id IS NULL THEN loc.loc_section ELSE NULL
END AS Loc_Section,

CASE 
	WHEN l.loan_id IS NULL THEN loc.loc_floor ELSE NULL
END AS Loc_Floor,

CASE 
	WHEN l.loan_id IS NULL THEN loc.shelf ELSE NULL
END AS Loc_Shelf,

CASE 
	WHEN l.due_date < "2025-12-01" 
    THEN "Check current status" ELSE NULL
END AS Comments

FROM BOOKS_STATUS bs

JOIN BOOK_COPIES bc ON bs.book_id = bc.book_id  
JOIN BOOKS b ON bc.isbn = b.isbn
JOIN STATUSES s ON bs.status_id = s.status_id
JOIN CONDITIONS c ON bs.condition_id = c.condition_id
LEFT JOIN BOOK_LOCATION loc ON bs.loc_id = loc.loc_id
LEFT JOIN LOANS l ON bs.book_id = l.book_id AND l.loan_id = (
	SELECT MAX(loan_id)
    FROM LOANS l2
    WHERE l2.book_id = bs.book_id AND l2.return_date IS NULL
	)

WHERE bs.condition_id = 5 -- Condition = Damaged
ORDER BY bs.book_id; 
 

/* -------------------------------------------------------------------------
	JULIETA 2nd QUERY: MORE COPIES NEEDED
	- Get a list of books with just one copy. And the status of the book.  (The dummydata doesn't have results with just one copy, so I did it with 2)
	- And indicate the author and the supplier of the only copy (contact details as well), so it can be contacted and ask for more copies.  
	- Check how many requests this book has (from Waitlist) 
	------------------------------------------------------------------------- */

-- FINAL Query
SELECT
x.ISBN, 
x.Book_Name,
x.Edition, 
x.Author,
x.On_Waitlist,
x.Last_CopyID,
sup.supplier_id AS LastCopy_SupplierID,
sup.supplier_name AS Supplier_Name,
sup.contact_person AS Contact_Name,
sup.phone_no AS PhoneNo,
sup.email AS Email

FROM SUPPLIERS sup
JOIN BOOK_COPIES bc ON sup.supplier_id = bc.supplier_id
    
RIGHT JOIN ( -- Query to filter by ISBN with only 2 copies (Result: 46 rows)
	SELECT 
	COUNT(*) AS Copies,
	bc2.isbn AS ISBN, 
	b2.book_name AS Book_Name,
	b2.edition AS Edition, 
	a2.author_name AS Author,
	w2.On_Waitlist AS On_Waitlist,
	MAX(bc2.book_id) AS Last_CopyID

	FROM BOOK_COPIES bc2

	JOIN BOOKS b2 ON bc2.isbn = b2.isbn
	JOIN AUTHORS a2 ON b2.author_id = a2.author_id

	LEFT JOIN ( -- Joining WAITLIST
		SELECT 
		COUNT(*) AS On_Waitlist,
		b22.isbn AS ISBN
		FROM Waitlist w22
		JOIN BOOKS b22 ON w22.isbn = b22.isbn

		GROUP BY b22.isbn
	) w2 ON b2.isbn = w2.ISBN 

	GROUP BY b2.isbn
	
	HAVING Copies = 2
	
) x ON bc.book_id = x.Last_CopyID

GROUP BY 
x.ISBN, 
x.Book_Name,
x.Edition, 
x.Author,
x.On_Waitlist,
x.Last_CopyID,
sup.supplier_id,
sup.supplier_name,
sup.contact_person,
sup.phone_no,
sup.email;

-- EXTRA - Check the copies for one ISBN
SELECT *
FROM BOOK_COPIES 
WHERE isbn = 9781000000005;
-- Checking Results: For this ISBN (it has 2 copies) the Last Copy should be ID 20 and its supplier ID 3

-- Checking how many ISBN has 2 copies. (46 rows should match with the full query)
SELECT isbn, COUNT(*) AS Copies
FROM BOOK_COPIES
GROUP BY isbn
HAVING Copies = 2;


/* -------------------------------------------------------------------------
	JULIETA 3rd QUERY: POPULAR LANGUAGES
	- Check how many book for each languages. And indicate how many loans in total 
	every language has had (either they have been returned or not) 
	- Add number of tuples in Waitlist by languages.
	------------------------------------------------------------------------- */

SELECT 
lan.language_book AS Book_Language,
COUNT(*) AS Total_Books,
tl.Loans_per_Language,
tw.Waitlist_per_Language

FROM BOOK_COPIES bc

JOIN BOOKS b ON bc.isbn = b.isbn
JOIN LANGUAGES lan ON b.language_id = lan.language_id

LEFT JOIN ( -- Subquery to get Total of Loans per Language -- Joining LOANS 
	SELECT COUNT(*) AS Loans_per_Language,
    lan2.language_book AS Book_Language,
    lan2.language_id AS Language_ID
    FROM Loans l2
    JOIN BOOK_COPIES bc2 ON l2.book_id = bc2.book_id
    JOIN BOOKS b2 ON bc2.isbn = b2.isbn
    JOIN LANGUAGES lan2 ON b2.language_id = lan2.language_id
    
    GROUP BY lan2.language_book,
    lan2.language_id
    
) tl ON tl.Language_ID = b.language_id

LEFT JOIN ( -- Subquery to get Total of Items on Waitlist per Language -- Joining WAITLIST 
	SELECT COUNT(*) AS Waitlist_per_Language,
    lan3.language_book AS Book_Language,
    lan3.language_id AS Language_ID
    FROM Waitlist w3
    JOIN BOOKS b3 ON w3.isbn = b3.isbn
    JOIN LANGUAGES lan3 ON b3.language_id = lan3.language_id
    
    GROUP BY 
    lan3.language_book,
    lan3.language_id
) tw ON tw.Language_ID = b.language_id

GROUP BY lan.language_book,
tl.Loans_per_Language,
tw.Waitlist_per_Language

ORDER BY Total_Books DESC;


/* -------------------------------------------------------------------------
	JULIETA 4th QUERY: REGULAR CUSTOMERS 
	- Enganging loyalty with the library community
	- Check the customers table and see how many books and how many devices they have borrowed. Order them by the highest amount of books borrowed.  
	- Indicate the day of the last loan. And depending on their owes, check if they are eligible and if they can get other 
    invitations if they don't owe anything.
	------------------------------------------------------------------------- */

SELECT 
l.customer_id AS Customer, 
cus.f_name AS First_Name,
cus.l_name AS Last_Name,
cus.email AS Email,
COUNT(l.book_id) AS Total_Book_Loans,
COUNT(l.device_id) AS Total_Device_Loans,
COUNT(*) AS Total_Loans,
SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) AS Total_Owe, -- This add 1 per empty return date, meaning they have to return it yet.

-- Next Due Date if they have anything to return
/*CASE 
	WHEN SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) > 0 
    THEN MIN(CASE WHEN l.return_date IS NULL THEN l.due_date END) 
	ELSE NULL END
AS Next_Due_Date, */

-- They are Eligible if zero overdue loans
-- If the due date is not due yet, then they are eligible as well. 
-- If they have more but this year, they are half elegible
-- If they have just one overdue in the past, they are under review.

CASE 
	WHEN SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) = 0 -- AND COUNT(*)/2 > SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) 
    THEN "YES" 
    
 	WHEN MIN(CASE WHEN l.return_date IS NULL THEN l.due_date END) > CURDATE() 
    -- Date when the query was created "2026-04-08", in case at the time to check the data doesn't have any due 
    THEN "YES"  
    
    WHEN MIN(CASE WHEN l.return_date IS NULL THEN l.due_date END) > "2026-02-01" AND MIN(CASE WHEN l.return_date IS NULL THEN l.due_date END) < CURDATE()
    THEN "HALF"
    
	WHEN SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) < 2 -- AND COUNT(*)/2 > SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) 
    THEN "UNDER REVIEW" 
    
    ELSE NULL END
AS Elegible,
    
-- Indicate Extra Recognition
CASE 
	WHEN SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) = 0 AND MAX(l.date_borrowed) > "2025-12-31"
    THEN "Invitation to Activities" 
    
	WHEN SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) = 0 AND MAX(l.date_borrowed) < "2025-12-31"
    THEN "Invitation to Come Back" 

    ELSE NULL END
AS Extra
    
-- Check Recent Activity 
-- MAX(l.date_borrowed) AS Last_Borrowed
    
FROM LOANS l

LEFT JOIN CUSTOMERS cus ON l.customer_id = cus.customer_id

GROUP BY 
l.customer_id

-- The result will be only with more than 2 loans and if they are Eligible or Under Review.
HAVING 
Total_Book_Loans > 3 AND
Elegible IS NOT NULL

ORDER BY 
Elegible DESC,
Total_Book_Loans DESC,
Total_Owe ASC;


-- EXTRA To check a individual customer based on the results 
SELECT *
FROM LOANS
HAVING customer_id = 83;

/* -------------------------------------------------------------------------
	EESHA QUERY 1: Department Staffing Costs
	This query shows how much the library is spending on staff in each department.
	It helps the manager see which teams (like "IT Support" or "Customer Service") 
	are the most expensive to run.
	------------------------------------------------------------------------ */

SELECT 
    D.dep_name AS Department,
    COUNT(S.staff_id) AS employee_count,
    SUM(S.salary) AS total_payroll,
    ROUND(AVG(S.salary), 2) AS avg_staff_salary,
    CASE 
        WHEN SUM(S.salary) > 100000 THEN 'High Expenditure'
        ELSE 'within budget'
    END AS budget_status
FROM DEPARTMENTS D
JOIN STAFF_HR S 
    ON D.department_id = S.department_id
GROUP BY D.dep_name
ORDER BY total_payroll DESC;

/* ------------------------------------------------------------------------- 
	EESHA QUERY 2: Value of Equipment in Each Room
	This query adds up the price of all computers and devices in each room. 
	It helps the library decide which rooms need extra security or better 
	locks because they contain expensive equipment. 
	------------------------------------------------------------------------- */

SELECT 
    R.room_name,
    COUNT(D.serial_no) AS device_count,
    SUM(D.cost) AS total_asset_value,
    CASE 
        WHEN SUM(D.cost) > 2000 THEN 'high value: enhanced security required'
        ELSE 'standard value'
    END AS room_security_level
FROM DEVICES D
JOIN DEVICE_STATUS DS 
    ON D.serial_no = DS.serial_no
JOIN ROOMS R 
    ON DS.room_id = R.room_id
GROUP BY R.room_name
HAVING total_asset_value > 0
ORDER BY total_asset_value DESC;

/* -------------------------------------------------------------------------
	EESHA QUERY 3: Department Revenue Reports
	See which staff departments are handling the items that generate the most fines; 
	helps see where most late returns are happening. 
	------------------------------------------------------------------------- */

SELECT 
    CASE 
        WHEN L.book_id IS NOT NULL THEN 'collections'
        WHEN L.device_id IS NOT NULL THEN 'IT support'
        ELSE 'other'
    END AS department_responsible,
    COUNT(L.loan_id) AS total_late_returns,
    SUM(F.fine_amount) AS total_fine_revenue
FROM LOANS L
JOIN FINES F 
    ON DATEDIFF(IF(L.return_date IS NULL, CURDATE(), L.return_date), L.due_date) = F.length_overdue
WHERE DATEDIFF(IF(L.return_date IS NULL, CURDATE(), L.return_date), L.due_date) > 0
GROUP BY department_responsible
ORDER BY total_fine_revenue DESC;

/* -------------------------------------------------------------------------
	EESHA QUERY 4: County Financial Risk
	Which counties have more 'bad borrowers' than others 
	------------------------------------------------------------------------- */

SELECT 
    A.county AS county_name, 
    COUNT(DISTINCT C.customer_id) AS number_of_late_borrowers,
    SUM(F.fine_amount) AS total_fine_money,
    ROUND(AVG(F.fine_amount), 2) AS average_fine_per_person
FROM CUSTOMER_ADDRESSES A
JOIN CUSTOMERS C ON A.customer_id = C.customer_id
JOIN LOANS L ON C.customer_id = L.customer_id
JOIN FINES F ON DATEDIFF(IF(L.return_date IS NULL, CURDATE(), L.return_date), L.due_date) = F.length_overdue
WHERE DATEDIFF(IF(L.return_date IS NULL, CURDATE(), L.return_date), L.due_date) > 0
GROUP BY county_name
ORDER BY total_fine_money DESC;
