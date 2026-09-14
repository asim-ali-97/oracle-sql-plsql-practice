select * from as_sales_persons;

alter table as_sales_persons 
drop constraint chk_sales_persons;

alter table as_sales_persons 
add constraint chk_joining_date 
check (joining_date >= date '2020-01-01'); 

insert into as_sales_persons 
values (7, 'Nasir', 'Ullah', 45700, date '2020-01-01', null, date '2000-01-01');

alter table as_sales_persons 
drop constraint chk_sales_person_jd_ld;

alter table as_sales_persons 
add constraint chk_sales_person_JD_LD 
check (joining_date <= leaving_date);

select * from as_products;
insert into as_products values (5, 'Safeguard', 100);

alter table as_products 
add constraint uq_products_name 
unique (product_name);

alter table as_products 
modify product_name not null;

--alter table as_products 
--add constraint NN_product_name 
--check (product_name is not null);

select * from as_products;
insert into as_sales 
values(113, 'C3', date '2023-11-02', 2, 2, 0, 10);

select * from as_sales;

alter table as_sales 
add constraint FK_sales_products 
foreign key (product_id) REFERENCES as_products (product_id);

alter table as_sales 
add constraint FK_sales_sales_persons 
foreign key (sales_person_id) 
references as_sales_persons (sales_person_id);

alter table as_sales 
add constraint chk_sales_neg_qty 
check (quantity >= 0);

alter table as_sales 
add constraint chk_sales_neg_ppUnit 
check (price_per_unit >= 0);

create table emp_table (
em_id number primary key
);
create table fk_emp_table (
coll_id number references emp_table(em_id)
);
desc emp_table;
drop table emp_table cascade constraints;

select * from user_tablespaces;
select * from user_users;

select dept_id, city, name from as_departments;
insert into as_departments (dept_id, city, name)
values (1, 'Lahore', 'Admin');

insert into as_departments (dept_id, name, city)
values (2, 'HR', 'Islamabad');

insert into as_departments (dept_id, name, city)
select 3, 'IT', 'Karachi' from dual;

select * from as_employees;
alter table as_employees drop column dob;

insert into as_employees 
(emp_id, first_name, last_name, dept_id, salary)
select 1002, 'Aga', 'Ali', 1, 32000 from dual;

--Update
select * from as_departments;
select * from as_employees;

update as_employees
set salary = salary + 5000;

update as_employees
set last_name = null --last name has not null constraint
where emp_id = 1002;

update as_employees
set emp_id = 1004
where first_name = 'Aga';

select * from as_employees;
insert into as_employees
(emp_id, first_name, last_name, dept_id, salary)
values (1008, 'Sana', 'Ali', 2, 49000);
