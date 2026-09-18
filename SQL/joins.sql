-- JOINS

-- Inner Join
select * from as_employees;
select * from as_departments;
update as_employees set dept_id = 3 where emp_id in (1005,1006);
commit;

select * 
from as_employees emp
join as_departments dep
on emp.dept_id = dep.dept_id; -- Recommended

insert into as_departments (dept_id, name, city)
values (2,'HR', 'Islamabad');
select * from as_departments;
commit;

select *
from as_employees e
join as_departments d
on e.dept_id = d.dept_id;--Here in inner join 
--now there will be no record for dpt_id 2 
--as it isn't present in the employees table

select *
from as_employees em
join as_departments dep
using (dept_id); -- Not recommended as there may be multiple tables

-- Left Outer Join
select *
from as_departments d
left join as_employees e
on d.dept_id = e.dept_id;

select * from as_employees;
update as_employees set salary = salary + 5000 where emp_id = 1002;
commit;

select * 
from as_departments d
left join as_employees e
on d.dept_id = e.dept_id
and e.salary > 40000;

update as_employees set salary = 39000 where emp_id = 1003;

select * 
from as_departments d
left join as_employees e
on d.dept_id = e.dept_id
where e.salary > 40000;

select * from as_departments;

-- Right outer join opposite of LJ
select *
from as_employees e
right join as_departments d
on e.dept_id = d.dept_id;



select * from as_employees;
select * from as_departments;

select * 
from as_employees e
join as_departments d
on e.dept_id = d.dept_id;

select *
from as_employees e
left join as_departments d
on e.dept_id = d.dept_id;

select * from as_employees e
right join as_departments d
on e.dept_id = d.dept_id;

select * from as_employees;
select * from as_departments;
select * from as_sales;

alter table as_employees drop constraint SALRY_CHK;
alter table as_employees modify dept_id null;
desc as_employees;

insert into as_employees (emp_id, first_name, last_name,dept_id, salary)
values (1001,'Nasir','Ali',2,120000);
commit;

--Full Outer Join
select *
from as_employees e
full outer join as_departments d
on (e.dept_id = d.dept_id)
and salary > 40000;

-- Practical of Inner and Outer join
select * from as_sales_persons;
select * from as_products;
select * from as_sales;

insert into as_sales values(113, 'C3', date '2024-12-03', 2,4,15,10);
insert into as_sales values(114, 'C4', date '2025-1-03', 2,1,15,10);
insert into as_sales values(115, 'C5', date '2024-2-14', 2,2,25,10);
insert into as_sales values(116, 'C6', date '2024-12-03', 2,4,35,10);
commit;

alter table as_products add (created_date date, last_updated_by varchar2(100),last_update_date date);
update as_products set created_by = 'T';
commit;
update as_products set created_by = 'F' where product_id in (4,5);
commit;
update as_products set created_date = date '2026-02-13';
commit;

--Data of sales with product name and sales person firstname,  and name of the creator of the product record.
select s.*, p.product_name, p.created_by, sp.first_name
from as_sales s 
inner join as_products p
on s.product_id = p.product_id
inner join as_sales_persons sp
on sp.sales_person_id = s.sales_person_id;

--All products with product details and sales person First name who sold them with their salary if no sales only product detials.
select p.*, sp.first_name, sp.salary
from as_products p
left join as_sales s
on p.product_id = s.product_id
left join as_sales_persons sp
on s.sales_person_id = sp.sales_person_id;

--All Products with product details and sales persons who sold them with their salary if no sales only product details.
select p.*, sp.first_name, sp.salary
from as_products p
left join as_sales s
on p.product_id = s.product_id
left join as_sales_persons sp
on s.sales_person_id = sp.sales_person_id;


-- all sales data with product name, product actual price, ales person name, sales person salary
-- order the result with sales person first name, if same then product actual price
select * from as_sales_persons;
select * from as_products;
select * from as_sales;

select s.*, p.product_name, p.price, sp.first_name, sp.salary
from as_sales s
left outer join as_products p
on s.product_id = p.product_id
left outer join as_sales_persons sp
on s.sales_person_id = sp.sales_person_id
order by first_name,price;

-- Ssles and product data for which product sold was at the actual product price
-- order the data using actual price * quantity then order the result in desc
select * from as_products;
select * from as_sales;

select * from as_sales s
inner join as_products p 
on s.product_id = p.product_id 
and s.price_per_unit = p.price
order by s.price_per_unit * s.quantity desc;

select s.*, p.*, s.price_per_unit * s.quantity as total_price
from as_sales s
inner join as_products p 
on s.product_id = p.product_id 
and s.price_per_unit = p.price
order by total_price desc; -- this total_price alias can only be used with 'order by'