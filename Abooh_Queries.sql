USE library_CA1_GroupE;
-- ABOOH QUERIES
/* -------------------------------------------------------------------------
	QUERY 1: Bad Borrowers
	Customers with total built up fines over €50, flagged against waitlist
    entries and room reservations for removal. But still showing those with 
    large fine amounts even if not on waitlist.
    - flaw we have no way to track if theyve payed their fine?
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
	QUERY 2: Device Warranty Alert
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
    CASE WHEN L.return_date IS NULL THEN 'Out on Loan' ELSE 'Available' END AS loan_status
FROM DEVICES D
LEFT JOIN LOANS L ON D.serial_no = L.device_id
WHERE DATEDIFF(D.warranty_end, IF(L.return_date IS NULL AND L.loan_id IS NOT NULL, L.due_date, CURDATE())) BETWEEN 0 AND 30
ORDER BY days_until_warranty_expires ASC;


/* -------------------------------------------------------------------------
	QUERY 3: Peak Demand Days
	Loans and room reservations grouped by day of the week to identify
	the busiest days of the year for staffing decisions
   ------------------------------------------------------------------------- */
SELECT
    day_of_week,
    COUNT(*) AS total_events
FROM (
    SELECT
        DAYNAME(L.date_borrowed) AS day_of_week
    FROM LOANS L
    JOIN CUSTOMERS C ON L.customer_id = C.customer_id
    WHERE YEAR(L.date_borrowed) = YEAR(CURDATE())

    UNION ALL

    SELECT
        DAYNAME(R.res_start) AS day_of_week
    FROM ROOM_RESERVATIONS R
    JOIN CUSTOMERS C ON R.customer_id = C.customer_id
    WHERE YEAR(R.res_start) = YEAR(CURDATE())
) AS combined_events
GROUP BY day_of_week
ORDER BY total_events DESC;
