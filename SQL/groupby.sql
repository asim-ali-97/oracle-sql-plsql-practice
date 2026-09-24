--GROUP BY and AGGREGATE Functions

-- the column numbers selected must be in the group by clause ie select product_name, product_id now both 
--should be in group by ie group by product_name, product_id

select * from as_employees;
select * from as_departments;

select d.name, count(*) as number_of_employees, sum(salary) as total_salary, avg(salary) as average_salary
from as_employees e 
join as_departments d
on e.dept_id = d.dept_id
group by d.name;

select dept_id, min(salary), max(salary)
from as_employees
group by dept_id;

select dept_id, listagg(firstname, ', ') within group (order by salary)
from as_employees
group by dept_id;

--Having
select *
from as_employees;
select dept_id from as_employees
group by dept_id
having count(*) < 5;

--When we dont use group by the whole table is considered as a group so having is used with group by
--and Aggregate functions are also used with group by, when no group by used whole table is considered a group by default
select count(*), sum(salary) as sum_of_salaries
from as_employees
having count(*) < 25;


--Practical of Group by and Aggregate Function
select * from as_sales_persons;
select * from as_products;
select * from as_sales;

--Number of sales persons
select count(*) from as_sales_persons;

--Number of Products
select count(*) from as_products;

--Number of sales done on each edible items after 2021, and total price 
select product_name, count(*), sum(s.quantity*s.price_per_unit) from as_sales s join as_products p on p.product_id = s.product_id
where sale_date >= date'2021-01-01'
and product_name in ('Tiger biscuit','Milk','oil')
group by product_name;

--Product sold more than once
select product_id, count(*) from as_sales
group by product_id
having count(*) > 1;
--OR
select p.product_name, count(*) as number_of_sales from as_sales s join as_products p on s.product_id = p.product_id
group by p.product_name
having count(*) > 1;

--Products sold with total price greater than 1000
select * from as_sales;
select product_id, sum(quantity*price_per_unit) as total_price from as_sales
group by product_id
having sum(quantity*price_per_unit) > 1000;

--Sales persons with first and last sale dates
select * from as_sales_persons;
select sp.sales_person_id, sp.first_name, min(sale_date) as first_sale, max(sale_date)as last_sale 
from as_sales_persons sp left join as_sales s on sp.sales_person_id = s.sales_person_id
group by sp.sales_person_id, sp.first_name;

--Average quantity sold per sale of each product sold till now
select * from as_sales;
select p.product_name, avg(quantity) as average_sale
from as_sales s join as_products p on s.product_id = p.product_id
group by p.product_id, p.product_name
order by p.product_id;
