USE library_CA1_GroupE;

/* -------------------------------------------------------------------------
------> JULIETA - 1st QUERY - REPARATION NEEDED 
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
------>  JULIETA - 2nd QUERY - MORE COPIES NEEDED
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
------> JULIETA - 3rd QUERY - POPULAR LANGUAGES
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
------> JULIETA - 4th QUERY -- 4th REGULAR CUSTOMERS 
- Enganging loyalty with the library community
- Check the customers table and see how many books and how many devices they have borrowed. Order them by the highest amount of books borrowed.  
-  Indicate the day of the last loan. And depending on their owes, check if they are eligible and 
-  if they can get other invitations if they don't owe anything.
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

