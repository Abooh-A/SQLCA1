-- eesha queries
/* query 1: department staffing costs
This query shows how much the library is spending on staff in each department.
It helps the manager see which teams (like "IT Support" or "Customer Service") are the most expensive to run.*/

USE library_CA1_GroupE;
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

/* query 2: value of equipment in each room
This query adds up the price of all computers and devices in each room. 
It helps the library decide which rooms need extra security or better locks because they contain expensive equipment. */

USE library_CA1_GroupE;
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

/* query 3: department revenue reports
see which staff departments are handling the items that generate the most fines; 
helps see where most late returns are happening. */

USE library_CA1_GroupE;
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

/* query 4: county financial risk
which county have more 'bad borrowers' than others */

USE library_CA1_GroupE;
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
