----      VIEW

-- view is a logical table which represents another table or view
-- it ia a query that has been named so is also called as named_query
-- it is a virtual table that doesnt stores data but can be used as a table like for joining etc
-- view provides security of data and it is also used for simplicity
-- we can use view to hide data from grants so that they cant be updated
--      updateable and non-updateable views
-- simple views are updateable views
-- however if we have used an aggregate function, joins, union (or any set operator), distinct or group by then such a view cannot be updated.

select * from as_employees;

-- Updateable view
create or replace view high_salaried_emp_vw as
select * from as_employees where salary > 45000;

select * from high_salaried_emp_vw;
insert into high_salaried_emp_vw values(1021,'Shazim','Khan',2,43000); -- here we are adding a value less than 45000 so it will be added to the emp table as we havent applied check but it wont show up in the above select query of the view

select * from high_salaried_emp_vw;
insert into high_salaried_emp_vw values(1022,'Aamir','Khan',3,45100); -- it will show up as salary is greater than 45000

create or replace view high_salaried_emp_vw as
select * from as_employees where salary > 45000
with check option;

insert into high_salaried_emp_vw values(1023,'Navid','Khan',2,42000); -- so now it doesnt allow to insert new data into emp table as salary is less than 45000 which has a check now
insert into high_salaried_emp_vw values(1023,'Navid','Khan',2,45200); -- 1 row inserted

select * from high_salaried_emp_vw;
select * from as_employees;

-- Non Updateable view
create or replace view non_updatable_emp_vw as
select dept_id, sum(salary) as salary from as_employees group by dept_id;

-- we can also use the [with read only] check to make a view read only.

select * from non_updatable_emp_vw;

--grant select on non_updatable_emp_vw to bi;
--revoke select on non_updatable_emp_vw from bi;

select * from
(select * from as_employees where dept_id = 3) e -- this is called inline view
join as_departments d on e.dept_id = d.dept_id;


--        MATERIALIZED VIEW
-- stores the data
/*
CREATE MATERIALIZED VIEW materialized_view_name
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE]
ON [COMMIT | DEMAND]
AS SELECT column1, column2, ... FROM table_name WHERE condition;
*/

-- for refreshing on demand
-- exec dbms_mview.refresh('materialized_view_name')

-- Create a view of sales of each product per second half of the year.
select * from as_sales;
select * from as_products;

create view vw_sale_second_half_of_year as
select p.product_id,p.product_name, sum(quantity)as quantity, avg(price_per_unit) as average_price
from as_sales s join as_products p on s.product_id = p.product_id
where to_number(to_char(sale_date,'mm')) >= 6
group by p.product_id,p.product_name;

select * from vw_sale_second_half_of_year where quantity < 40;


-- Create on demand complete refresh materialized view for each product with sum of sales sold in quantity greater than 30.
create materialized view mvw_prod_sale_qty_gretr_30
build IMMEDIATE
refresh COMPLETE
on DEMAND
AS
select p.product_id,p.product_name, sum(quantity) as total_quantity, avg(price_per_unit) as average_price, sum(quantity*price_per_unit) as total_amount
from as_products p left outer join as_sales s on p.product_id = s.product_id and s.quantity > 15
group by p.product_id, p.product_name;
commit;
update as_sales set quantity = 16 where sale_id = 117;
commit;
select * from mvw_prod_sale_qty_gretr_30;
exec dbms_mview.refresh('mvw_prod_sale_qty_gretr_30');
select * from mvw_prod_sale_qty_gretr_30;

select * from as_sales;
select * from as_products;

--drop materialized view mvw_prod_sale_qty_gretr_30;
