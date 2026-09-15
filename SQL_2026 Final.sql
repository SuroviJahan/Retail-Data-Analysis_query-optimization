-- 1. Creating a new database (schema) in MySQL workbench
CREATE DATABASE SUROVIPROJECT1_2026
;
-- 2.  Creating a new table called clients and insert following values into the clients table:
  -- (client_id, client_name, street_address, city, state, phone_number)
USE suroviproject1_2026
;
-- Create table inside database
CREATE TABLE Clients_SQLProject1 (
client_id INT,
client_name VARCHAR(50),
street_address VARCHAR(30),
city VARCHAR(20),
state VARCHAR(12),
 phone_number VARCHAR(12)
 );

 -- insert data into the table
INSERT INTO Clients_SQLProject1(client_id,client_name,street_address,city,state,phone_number)
VALUES
(1,'Vinte','3 Nevada Parkway','Syracuse','NY','315-252-7305'),
(2,'Myworks','34267 Glendale Parkway','Huntington','WV','304-659-1170'),
(3,'Yadel','096 Pawling Parkway','San Francisco','CA','415-144-6037'),
(4,'Kwideo','81674 Westerfield Circle','Waco','TX','254-750-0784'),
(5,'Topiclounge','0863 Farmco Road','Portland','OR','971-888-9129')
;

-- 3.Importing all the other .csv files as tables into the schema

-- 4. Data Retrieval: Writing .sql query following questions:
-- a) Giving me the list of unique states from ‘customers’ table
SELECT DISTINCT state
FROM `mosh_customers (1)`;

-- b) Saying a new price for products is set as the 1.1times the unit_price. How would the new price look like in ‘products’ table
SELECT product_id, name , unit_price, unit_price * 1.1
FROM mosh_products
;


-- c) Showing the invoice_id, client_id, invoice_total, payment_total, invoice_date and due_date from the ‘invoices’ 
-- table after the invoice_date June 2019.
SELECT invoice_id,
       client_id,
       invoice_total,
       payment_total,
       invoice_date,
       due_date
FROM `mosh_invoices (1)`
WHERE invoice_date > '2019-06-30'
;
-- d) Identifying those customers (from ‘customers’ table) who were born after 1990 having points more than 1000.
SELECT *
FROM `mosh_customers (1)`
WHERE birth_date > '1990-12-31'
  AND points > 1000
  ;
  
-- e) Finding out those clients from ‘payments’ table with client_id 5 having amount more than 20.00
SELECT *
FROM mosh_payments
WHERE client_id = 5
  AND amount > 20.00
  ;
  -- f) Identifying those products which are less expensive than lettuce from products table

SELECT *
FROM mosh_products
WHERE unit_price < (
    SELECT unit_price
    FROM mosh_products
    WHERE name like '%Lettuce%'
);
-- --5 a. Payment method names used in payments, via join with payment_methods
SELECT payment_id,
       client_id,
        amount,
       name AS payment_method_name
FROM mosh_payments as p
JOIN mosh_payment_methods as pm
    ON p.payment_method = pm.payment_method_id
    ;
   -- b. Showing the client_id, name, state, payment_total, due_date, payment_date, phone by joining the tables: clients, invoices
SELECT 
    c.client_id,
    c.client_name,
    c.state,
    i.payment_total,
    i.due_date,
    i.payment_date,
    c.phone_number
FROM clients_sqlproject1 AS c
JOIN `mosh_invoices (1)` AS i
    ON c.client_id = i.client_id
    ;
    
  -- c. Finding out the name of the clients with at least 2 invoices from clients and invoices tables
  SELECT 
    c.client_name,
    COUNT(i.invoice_id) AS invoice_count
FROM clients_sqlproject1 AS c
JOIN `mosh_invoices (1)` AS i
    ON c.client_id = i.client_id
GROUP BY c.client_id, c.client_name
HAVING COUNT(i.invoice_id) >= 2
;
    
    -- 6. Manipulating multiple tables:
-- a) Finding the first name, last name, and points of customers whose points are greater than the average points of all customers.
SELECT 
    first_name,
    last_name,
    points
FROM `mosh_customers (1)`
WHERE points > (
    SELECT AVG(points)
    FROM `mosh_customers (1)`
);

-- b) -- Finding clients without any invoices, output their names (with details)
SELECT 
    c.client_id,
    c.client_name,
    c.street_address,
    c.city,
    c.state,
    c.phone_number
FROM clients_sqlproject1 AS c
LEFT JOIN `mosh_invoices (1)` AS i
    ON c.client_id = i.client_id
WHERE i.invoice_id IS NULL
;

-- c) Finding out all information about clients who have invoice_total larger than client-3 from invoices and clients table.
    SELECT 
    c.*,
    i.invoice_total
FROM clients_sqlproject1 AS c
JOIN `mosh_invoices (1)` AS i
    ON c.client_id = i.client_id
WHERE i.invoice_total > (
    SELECT max(invoice_total)
    FROM `mosh_invoices (1)`
    WHERE client_id = 3
);

-- d) Partitioning and ranking clients based on their invoice_total from invoices table
SELECT 
    client_id,
    invoice_id,
    invoice_total,
    RANK() OVER (
        PARTITION BY client_id 
        ORDER BY invoice_total DESC
    ) AS invoice_rank
FROM `mosh_invoices (1)`
;

-- e) Calculating the running total of the invoice_total for the same table
SELECT 
    invoice_id,
    client_id,
    invoice_date,
    invoice_total,
    SUM(invoice_total) OVER (
        ORDER BY invoice_date, invoice_id
    ) AS running_total
FROM `mosh_invoices (1)`
;

-- f) Retrieving the number from invoices table who chose payment method-1 in payments table
SELECT 
    i.number,
    i.invoice_id,
    p.payment_method
FROM `mosh_invoices (1)` AS i
JOIN mosh_payments AS p
    ON i.invoice_id = p.invoice_id
WHERE p.payment_method = 1
;

-- The End

