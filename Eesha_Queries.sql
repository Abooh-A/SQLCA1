-- eesha queries
/* query 1: dead debt
identify how much money is owed by people who are already banned (restricted) */

USE library_CA1_GroupE;
SELECT 
    C.f_name,   
    C.l_name,  
    SUM(F.fine_amount) AS total_debt_owed,
    CASE 
        WHEN SUM(F.fine_amount) > 15.00 THEN 'RESTRICTED'
        ELSE 'Active'
    END AS account_status
FROM CUSTOMERS C
JOIN LOANS L ON C.customer_id = L.customer_id
JOIN FINES F ON DATEDIFF(L.return_date, L.due_date) = F.length_overdue
WHERE L.return_date > L.due_date
GROUP BY C.customer_id, C.f_name, C.l_name
HAVING SUM(F.fine_amount) > 0.00;

/* query 2: budget replacement forecast
identify which devices are getting too old; flags old equipment */

/* query 3: department revenue reports
see which staff departments are handling the items that generate the most fines; helps see where most late returns are happening. */

/* query 4: county financial risk
which county have more 'bad borrowers' than others */
