-- SET OPERATORS
-- Union and Union all
select emp_id, first_name, last_name, salary
from as_employees
union all
select sales_person_id, first_name, last_name, salary
from as_sales_persons;

select first_name, last_name, salary
from as_employees
union     -- will remove duplicates and sort
select first_name, last_name, salary
from as_sales_persons;

select first_name as F_N, last_name as L_N, salary
from as_employees
union all    -- wont remove duplicates and wont sort
select first_name, last_name, salary
from as_sales_persons;

-- Minus  --> removes duplicate and sorts
select * from as_employees;
select * from as_sales_persons;

select first_name, last_name, salary
from as_employees 
minus
select first_name, last_name, salary
from as_sales_persons;

-- Intersect  --> removes duplicate and sorts
select * from as_employees;
select * from as_sales_persons;

select first_name, last_name, salary
from as_employees 
intersect
select first_name, last_name, salary
from as_sales_persons;

-- Practical on Set Operators
-- all product with sale price and base price with tag for sold, base
select product_id, product_name, 'Base Price' as price_type, price from as_products
union
select product_id, null as product_name, 'Sold Price' as price_type, price_per_unit from as_sales;

-- each products various price (either base or sold) -- product and price columns only
select product_id, price from as_products
union
select product_id, price_per_unit from as_sales;

-- sales id of the sales persons who sold atleast one product
select * from as_sales;
select * from as_sales_persons;

select sales_person_id from as_sales_persons
intersect
select sales_person_id from as_sales;

-- sales id of the sales person who have not sold any product
select sales_person_id from as_sales_persons
minus
select sales_person_id from as_sales;

-- DOB, Joining and Leaving date of each sales persons -- three records per sales person 
-- one with DOB, one with joining date and one with leaving date
select sales_person_id, first_name, last_name, 'DOB' as date_type, dob from as_sales_persons
union
select sales_person_id, first_name, last_name, 'JOINING DATE' as date_type, joining_date from as_sales_persons
union
select sales_person_id, first_name, last_name, 'LEAVING DATE' as date_type, leaving_date from as_sales_persons;