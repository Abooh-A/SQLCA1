-- eesha queries
/* query 1: department staffing costs
This query shows how much the library is spending on staff in each department.
It helps the manager see which teams (like "IT Support" or "Customer Service") are the most expensive to run.*/

USE library_CA1_GroupE;
SELECT 
    D.dep_name AS Department,
    COUNT(S.staff_id) AS Employee_Count,
    SUM(S.salary) AS Total_Payroll,
    ROUND(AVG(S.salary), 2) AS Avg_Staff_Salary,
    CASE 
        WHEN SUM(S.salary) > 100000 THEN 'High Expenditure'
        ELSE 'Within Budget'
    END AS Budget_Status
FROM DEPARTMENTS D
JOIN STAFF_HR S ON D.department_id = S.department_id
GROUP BY D.dep_name
ORDER BY Total_Payroll DESC;

/* query 2: value of equipment in each room
This query adds up the price of all computers and devices in each room. 
It helps the library decide which rooms need extra security or better locks because they contain expensive equipment. */

USE library_CA1_GroupE;
SELECT 
    R.room_name,
    COUNT(D.serial_no) AS Device_Count,
    SUM(D.cost) AS Total_Asset_Value,
    CASE 
        WHEN SUM(D.cost) > 2000 THEN 'High Value: Enhanced Security Required'
        ELSE 'Standard Value'
    END AS Room_Security_Level
FROM DEVICES D
JOIN DEVICE_STATUS DS ON D.serial_no = DS.serial_no
JOIN ROOMS R ON DS.room_id = R.room_id
GROUP BY R.room_name
HAVING Total_Asset_Value > 0
ORDER BY Total_Asset_Value DESC;

/* query 3: department revenue reports
see which staff departments are handling the items that generate the most fines; 
helps see where most late returns are happening. */

/* query 4: county financial risk
which county have more 'bad borrowers' than others */
