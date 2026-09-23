-- OPERATORS -->> Comparison and Logical operators
select * from as_employees;
select * from as_departments;

-- IN and EXISTS
select * from as_employees where dept_id in (select dept_id from as_departments where city = 'Islamabad');
select * from as_departments where dept_id in (select dept_id from as_employees where salary <= 39000);
select * from as_departments where dept_id not in (select dept_id from as_employees where salary <= 39000);

-- find the employees of a dept where a employee surnamed Ahmad is working
select * from as_employees 
where dept_id in 
    (select dept_id  --subQuery (can be run seperately)
    from as_employees 
    where lastname = 'Ahmad');

select * from as_employees e
where exists 
    (select 1 from as_employees ee --coorelated subQuery (cant be run seperately)
    where e.dept_id = ee.dept_id
    and ee.lastname = 'Ahmad');
    

-- Find the products that have a price higher than the avg price of all products
select * from as_products;
select * from as_products where price > (select avg(price) from as_products);

-- Logical Operators (and, or, not)
select * from as_employees where first_name > 'B' and salary > 10000;
select * from as_employees where first_name > 'B' or salary > 100000;
select * from as_employees where not (first_name > 'B' or salary > 100000);

-- Operators Practical

-- product details of proucts with price ranging from 10 to 100
select * from as_products where price between 10 and 100;
select * from as_products where price >= 10 and price <= 100;

-- product details of proucts with price ranging from 10 to 100 and edible
select * from as_products where price between 10 and 100 and product_name in ('Tiger biscuit','Milk','oil');

-- Sales details of the sales with quantity very less (<=10) or very high (>=30)
select * from as_sales where quantity <= 10 or quantity >= 30;

-- sales details of the sales done in 2024
select * from as_sales where sale_date between date '2024-01-01' and date '2024-12-31';

-- product details of the sale done in 2023
select * from as_products 
where product_id in (
    select product_id from as_sales 
    where sale_date between date '2023-01-01' 
    and date '2023-12-31');

-- product details of the product which were not sold at their base price even once
select * from as_products;
select * from as_sales;

select * from as_products p 
where not exists (
    select 1 from as_sales s where p.product_id = s.product_id and p.price = s.price_per_unit) -- this will return the product that either doesnt exist in sales or their sales and original price doesnt match
and exists (                                                                  
    select 1 from as_sales s where p.product_id = s.product_id); -- and this will return the products that exist in sales table and return the product which was never sold in original price

-- Product detail of products which were sold at their original price only
select * from as_products p
where not exists (select 1 from as_sales s where p.product_id = s.product_id and p.price != s.price_per_unit)
and exists (select 1 from as_sales s where p.product_id = s.product_id);

-- sales persons who sold only edible items = Tiger Biscuit, Milk, Oil
select * from as_sales;
select * from as_sales_persons;

select * from as_sales_persons sp
where exists (select 1 from as_sales s join as_products p on s.product_id = p.product_id where sp.sales_person_id = s.sales_person_id
and p.product_name in ('Tiger biscuit','Milk','oil')
);


--Updated and working
select * from as_sales_persons sp
where exists (
    select 1 from as_sales s join as_products p on s.product_id = p.product_id 
    where sp.sales_person_id = s.sales_person_id 
    and p.product_name in ('Tiger biscuit','Milk','oil')
) and not exists (
    select * from as_sales s join as_products p on s.product_id = p.product_id 
    where sp.sales_person_id = s.sales_person_id 
    and p.product_name not in ('Tiger biscuit','Milk','oil'));

select s.sales_person_id, p.product_name, sp.first_name, p.product_id 
from as_products p 
inner join as_sales s 
on p.product_id = s.product_id inner join as_sales_persons sp 
on s.sales_person_id = sp.sales_person_id;