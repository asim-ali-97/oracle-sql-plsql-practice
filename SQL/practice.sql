-- String Function
--concat
select * from as_employees;

select emp_id, concat(firstname,lastname) as fullname, salary from as_employees;
select emp_id, firstname || ' ' || lastname as fullname, salary
from as_employees;

--upper and lower
select lower(firstname) as lower_name from as_employees;
select upper(lastname) as upper_name from as_employees;

-- trim
select firstname,lastname from as_employees
where firstname <> trim(firstname);

select * from as_employees;
select 
    firstname, 
    length(firstname) as len_name,
    length(trim(firstname)) as len_trim_name,
    length(firstname) - length(trim(firstname)) as flag from as_employees
where firstname <> trim(firstname);

-- replace
select '123/234/223', replace('123/234/223','/','-') as cleaned_phone from dual;
select 'report.txt' as old_file_name, replace('report.txt','.txt','.csv') as new_file_name
from dual;

-- length
select firstname, length(firstname) as len_name from as_employees;

-- substr
select firstname, substr(firstname,1,2) as firt_two_char from as_employees;
select firstname, substr(firstname,-2) as last_2_char from as_employees;
--yt -select the firsrname excluding the first two characters
select firstname, substr(firstname,3,length(firstname)) as sub_name from as_employees;

-- Numeric Functions
-- absolute ABS
select abs(-10) from dual;
-- round
select 3.153, round(3.153, 2) from dual; --3.15
select 3.532, round(3.532, 0) from dual; --4


-- Splitting string into two columns
-- substr and instr
create table parse_table
(sales_order varchar2(100),
creation_date date);

insert into parse_table
select '100000000*200000', sysdate from dual;
desc parse_table;

select * from parse_table;
commit;
select substr(sales_order,1, instr(sales_order, '*',1,1)-1) as left_half,
instr(sales_order, '*', 1, 1) as star_position,
substr(sales_order, instr(sales_order, '*',1,1)+1) as right_half, sales_order from parse_table;

select substr(sales_order, 1, instr(sales_order, '*',1,1)-1) left_portion,
substr(sales_order, instr(sales_order, '*',1,1)+1) right_portion,
instr(sales_order,'*', 1,1) star_position,
sales_order
from parse_table;

create table parse_table2
(full_name varchar2(100),
creation_date timestamp);

insert into parse_table2 select 'Sana, Ullah',sysdate from dual;
commit;
select full_name, to_char(creation_date, 'dd-mon-yy hh:mi:ssPM') creation_date from parse_table2;

select substr(full_name, 1, instr(full_name,',',1,1)-1) first_name,
substr(full_name,instr(full_name,',')+2) last_name,
instr(full_name, ',') comma_position,
full_name
from parse_table2;



-- find the employees of a dept where a employee surnamed Ahmad is working
select * from as_employees where dept_id in (select dept_id from as_employees where lastname = 'Ahmad');

select * from as_employees e
where exists (
    select 1 from as_employees ee 
    where e.dept_id = ee.dept_id
    and ee.lastname = 'Ahmad'
);

select dept_id, listagg(firstname,', ') within group (order by lastname) from as_employees group by dept_id;

select product_id, listagg(customer_name, ', ') within group (order by customer_name desc) from as_sales
group by product_id;


select count(*), sum(price_per_unit) as total_sum, avg(price_per_unit) as Avg_price, min(price_per_unit), max(price_per_unit) 
from as_sales group by product_id;

--Average quantity sold per sale of each product sold till now
select * from as_products;
select p.product_name, avg(quantity) as average_sale
from as_sales s join as_products p 
on s.product_id = p.product_id 
group by p.product_id,p.product_name
order by p.product_id;

--Sales persons with first and last sale dates
select * from as_sales;
select concat(first_name,last_name)as full_name,dob, min(sale_date) as first_sale, max(sale_date) as last_sale from as_sales_persons sp join as_sales s on sp.sales_person_id = s.sales_person_id
group by first_name,dob,last_name;



-- Deleting Duplicate rows in a table
select c.*, rowid from cust_one c;
insert into cust_one (cust_name) values('Asim ali');
select max(rowid) max_id, cust_name  from cust_one group by cust_name;

delete from cust_one
where rowid not in (select max_id from (select max(rowid) max_id, cust_name  from cust_one group by cust_name));

delete from cust_one
where rowid not in (select tab.max_id from (select max(rowid) as max_id, max(cust_id) cust_id, cust_name  from cust_one group by cust_name) tab); -- this is basically an inline view and we are using that to delete data.

rollback;

select c.* from cust_one c;
alter table cust_one rename column cust_job to job_name;
alter table cust_one add cust_salary number;
update cust_one set job_name = 'Teacher', cust_salary = 7000 where cust_id = 2;
update cust_one set job_name = 'Manager', cust_salary = 5000 where cust_id = 3;
update cust_one set job_name = 'Developer', cust_salary = 12000 where cust_id between 4 and 9;
commit;


-- remove duplicates form table cust_one
select * from cust_one;

delete from cust_one where rowid not in
(select tab.max_id from (select max(rowid) as max_id, cust_name, job_name from cust_one group by cust_name, job_name) tab); -- here we have not taken the salary so it assumed the record to be duplicate for same name and job when salary was different.
rollback;

delete from cust_one where rowid not in ( 
    select tab.max_id from (
        select max(rowid) as max_id, cust_name, job_name, cust_salary 
        from cust_one
        group by cust_name, job_name, cust_salary) tab);

select * from cust_one;
rollback;