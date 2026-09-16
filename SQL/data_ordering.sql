--Order by Clause
select * from as_sales_persons;
select * from as_sales_persons order by salary desc;
select * from as_sales_persons order by salary desc,sales_person_id; -- Using Col Name
select * from as_sales_persons order by 4 desc,1; -- Using Columns position
select * from as_sales_persons order by leaving_date nulls first;

-- fetch and offset
select * from as_sales_persons
order by salary desc
fetch first row only;

select * from as_sales_persons
order by salary desc
offset 3 rows
fetch first row only;

select * from as_sales_persons
order by salary desc
offset 3 rows
fetch first row with ties;

select * from as_sales_persons
order by salary
fetch first row with ties;

select * from as_sales_persons;
select * from as_products;

alter table as_products add created_by varchar2(100);
update as_products set created_by = 'T';
update as_products set created_by = 'F' where product_id in (4,5);


select * from as_products order by created_by;
select * from as_products order by created_by,price;
select * from as_products order by created_by,price desc;
select * from as_products order by created_by desc,price desc;

-- Top n records
select * from as_products order by price desc 
fetch first 3 rows only;
select * from as_products order by price
offset 3 rows
fetch first 1 rows only;
select * from as_products order by price
offset 1 rows
fetch first 2 rows only;

