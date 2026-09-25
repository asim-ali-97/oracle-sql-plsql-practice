--                  SQL FUNCTIONS IN ORACLE

-- CONVERSION FUNCTIONS -- to_char, to_number, to_date
-- explicit conversion 

-- To_Char --> use case is mostly for conversion and for Displays
select to_char(234) from dual;
select to_char(date '2024-12-24') from dual; --here we didnt pass the format so it picked the default format from NLS parameters
select to_char(date '2024-12-24', 'dd-mm-yyyy') from dual;
select to_char(date '2024-12-24', 'mm-dd-yyyy') from dual;
select to_char(sysdate, 'yy') from dual;
select to_char(sysdate, 'mm') from dual;
select to_char(sysdate, 'dd') from dual;
select to_char(sysdate, 'hh') from dual;
select to_char(sysdate, 'mi') from dual;
select to_char(sysdate, 'ss') from dual;

-- To_Number
select TO_NUMBER('123') from dual;
select to_number('55,534','99,999') from dual; --if no format given it it will give error
select to_number('55,666.4545','00,000.0000') from dual;
select to_number('$35','$99') from dual;

-- L -- Currency
-- D -- Digit Seperator
-- G -- Group Seperator

select '$5.6' from dual; --> $5.6 type string
select to_number('$5.5','L9D9') from dual; --> 5.6  type number
select to_number('$56,732.89','L99G999D99') from dual;

select * from nls_session_parameters;

-- To_Date
select date '2033-03-25' from dual;
select to_date('2033-03-25','yyyy-mm-dd') from dual; --> 25-MAR-33
select to_date('20-mar-2035') from dual; --> 20-MAR-35
select to_char(to_date('18-04-57','dd,mm,yy'), 'dd-mm-yyyy') from dual; --> 18-04-2057
select to_char(to_date('18-04-57','dd,mm,rr'), 'dd-mon-yyyy') from dual; --> 18-apr-1957
-- yy -20 -> 2001-2099
-- rr -19 -> 1951-2050
-- if we have used two digits(23) for year only then yy and rr are of significance else no need ie for (2024)

-- date with time
select to_date('18-04-57 08:23:44','dd,mm,yyyy hh:mi:ss') from dual; --> 18-APR-57
select to_char(to_date('18-04-57 08:23:44','dd,mm,yy hh:mi:ss'),'dd,mm,yyyy hh:mi:ss') from dual; --> 18,04,2057 08:23:44


-->> NULL HANDLING FUNCTIONS -- (nvl,nvl2,coalesce,nullif,lnnvl)

-- nvl  --> will return the the second param if the first one is null otherwise return first parameter
select * from as_employees;
select firstname, lastname, nvl(dept_id, 44) from as_employees; 

-- nvl2 --> Returns second param if the 1st is not null, if 1st is null returns the 3rd param
select nvl2('234','Head','Tail') from dual; -- Head
select nvl2('','Head','Tail') from dual; -- Tail
select nvl2(null,'Head','Tail') from dual; -- Tail
-- nvl2 can be used as nvl as
select firstname, lastname, nvl2(dept_id,dept_id, 44) from as_employees; 

-- coalesce --> return the first non null values in the parameters
select coalesce(23,43,53,12,53,3,5) from dual; -- 23
select coalesce(null,null,null,12,53,3,5) from dual; -- 12
-- can be used as nvl as
select firstname, lastname, coalesce(dept_id,44) from as_employees;

-- nullif --> accepts two params and returns null if both are same and first param if both are not same
select nullif(2,2) from dual; -- null
select nullif(1,2) from dual; -- 1

-- lnnvl -- returns all those values which dont satisfy the condition including null
select * from as_employees where lnnvl(dept_id > 1);


-->> CONDITIONAL FUNCTIONS -- decode, case
-- decode
select * from as_employees;
select firstname, lastname, dept_id,
decode(dept_id, 1, 'He/She is HR', 2, 'He/She is Admin', null, 'Unknown', 'Default') as description
from as_employees;

-- case
select firstname, lastname, dept_id,
case dept_id
when 1 then 'He/She is HR'
when 2 then 'He/She is Admin'
when null then 'Unknown' -- it matches the null like id = null so it is always false not like the decode which uses 'id is null' to match null
else 'Default'
end as description
from as_employees; 

-- we can use case in a more flexible way using the below syntax and null will also be handled using is
select firstname, lastname, dept_id,
case
when dept_id = 1 then 'He/She is HR'
when dept_id = 2 then 'He/She is Admin'
when dept_id is null then 'Unknown'
else 'Default'
end as description
from as_employees;

-- we can also add multiple conditions
select firstname, lastname, dept_id, salary,
case
when dept_id = 1 then 'He/She is HR'
when dept_id = 2 and salary > 60000 then 'He/She is a Rich Admin'
when dept_id = 2 and salary <= 60000 then 'He/She is a Poor Admin'
when dept_id is null then 'Unknown'
else 'Default'
end as description
from as_employees;


-->> NUMERIC FUNCTIONS -- operators, abs, ceil, floor, mod, round, trunc, power

-- operator
select 500+400 from dual;
select 300-500 from dual;
select emp_id, firstname || ' ' || lastname as fullname, salary, salary * .15 as hike from as_employees; 
select emp_id, firstname, lastname, salary, salary * .15 as hike, salary * 1.15 as incremented_salary from as_employees;

-- abs, ceil, floor and mod
select abs(300-400) from dual;
select abs(3000) from dual;
select emp_id, concat(firstname,lastname) fullname, salary/3 from as_employees;
select emp_id, concat(firstname,lastname) fullname,salary, salary/3, ceil(salary/3) as ten_day_salary from as_employees;
select emp_id, concat(firstname,lastname) fullname,salary, salary/3, floor(salary/3) as ten_day_salary from as_employees;
select mod(10,3) from dual;
select mod(20,3) from dual;

-- round
select round(2.342) from dual;  --2
select round(6.89) from dual;  --7
select round(3.235, 2) from dual; --3.24

-- trunc
select trunc(4.12) from dual; --4
select trunc(43.5234) from dual; --43
select trunc(-3.234) from dual; -- -3

-- power
select power(4,2) from dual; --16
select power(3,3) as power from dual; --27


-- CHARACTER FUNCTIONS IN ORACLE  -- lower, upper, initcap, length, substr, instr, replace, translate, lpad, rpad, ltrim, rtrim, trim, concat, ascii
select lower('THIS IS TO BE LOWERED') from dual;
select upper('this is to be uppercase') from dual;
select initcap('its initial character should be in capital') from dual;
select length('counting lenght of the strings') from dual;

select substr('Asim has a pet',5) from dual;
select substr('Asim has a pet',1,4) from dual;
select substr('this is small string',30,4) from dual; -- will give null istead of throwing error (ie oracle gracefully handles this)

select instr('123456789 index of 6','6',1,1) from dual;
select instr('123456789 index of 6','6',1,2) from dual;
select instr('the cow is on the road','road') from dual; --19
select instr('the cow is on the road','Road') from dual; -- 0 cux instr is case sensitive

select replace('Asim_ali','_',' ') from dual;
select replace('Asim ali','Asim','Wahib') from dual; -- Wahib ali
select replace('Asim ali','asim','Nasir') from dual; -- Asim ali  -- cux replace is also case sensitive so wont find asim and gives the original
select replace('Ba ra k -Obama',' ','') from dual; -- Barak-Obama

select translate(firstname,'asdf','1234') from as_employees; -- it will replace character by character ie a with 1 s with 2 (case sensitive) & so on. Used for encription purpose
select translate(firstname,'aAsim','pqrst') from as_employees; -- and it will drop the character when no replacement available

select rpad('asim',10,'*') from dual;
select firstname, rpad(firstname,10,'*') from as_employees;
select firstname, rpad(firstname,6,'*') from as_employees;
select firstname, lpad(firstname,10,'*') from as_employees;
select firstname, lpad(firstname,10) from as_employees; -- when not given will add space to it on lpad and rpad
select firstname, lpad(firstname,10,'-') as padded_text from as_employees;

select firstname, ltrim(lpad(firstname,10,'*'),'*') from as_employees;
select firstname, rtrim(rpad(firstname,10,'-'),'-') from as_employees;
select ltrim('---asim','-') from dual;
select rtrim('asim*****','*') from dual;
select trim('-' from '---asim---') from dual; -- asim
select trim('*' from '***asim***') from dual; -- asim
select trim('   asim                        ') from dual;
select trim('*' from '***as**im****') from dual; -- as**im wont remove the * from inside the name
select concat('Al','most') from dual;
select 'Asim' || ' ' || 'Ali' from dual;

select ascii('a') from dual; -- 97
select ascii('asim') from dual; -- 97
select ascii('z') from dual; -- 122


-- DATE FUNCTIONS in Oracle -- sysdate, current_date, systimestamp, current_timestamp, extract, last_day, months_between, next_day, trunc, round, dbtimezone, sessiointimezone and operator on date, add_months
select sysdate from dual; -- returns current date and time of the oracle server
select current_date from dual; -- returns current date and time of the session (machine where query is executed)
select systimestamp from dual; -- returns the current timestamp of the server time along with the time zone.
select current_timestamp from dual; -- returns the current timestamp of the session(local machine) time along with the time zone.
select systimestamp, current_timestamp from dual;
select extract(year from sysdate) from dual; -- 2026
select extract(month from sysdate) from dual; -- month ie 7
select extract(day from sysdate) from dual; -- day ie 5
select extract(hour from sysdate) from dual; -- will give error works with systimestamp
select extract(hour from systimestamp) from dual;
select extract(minute from systimestamp) from dual;
select extract(second from systimestamp) from dual; -- 37.031
select systimestamp from dual;
select * from nls_session_parameters where parameter = 'NLS_LANGUAGE';

select last_day(sysdate) from dual;
select last_day(date '2026-02-22') from dual;
select months_between(sysdate,date '2026-02-22') from dual;
select months_between(date '2026-02-22', date '2025-02-22') from dual; --12  --left date should be greateer
select months_between(sysdate, date '1997-02-03')/12 from dual;
select next_day(sysdate, 'fri') from dual;
select next_day(date'2026-02-12', 'sun') from dual; -- 15-feb-26
select systimestamp from dual; -- 07-JUL-26 08.08.13.737000000 AM -07:00
select trunc(systimestamp) from dual; -- 07-JUL-26
select trunc(systimestamp, 'year') from dual; -- 01-JAN-26 start of the year
select round(sysdate, 'year') from dual;
select round(date '2026-03-31','day') from dual; -- divides month into 7 days and then rounds on them ie 1-8-15-22-29
select round(to_date('2022-02-23 13:30:25', 'yyyy-mm-dd hh24:mi:ss' )) from dual; --24-FEB-22
select round(sysdate, 'month') from dual;
select round(date '2026-03-17', 'month') from dual; -- 01-APR-26
select round(date '2026-03-12', 'month') from dual; -- 01-MAR-26
select round(date '2026-03-17', 'year') from dual; -- 01-JAN-26
select round(date '2026-07-17', 'year') from dual; -- 01-JAN-27

select dbtimezone from dual; -- -05:00
select sessiontimezone from dual; -- America/Los_Angeles

-- altering nls_session_params
select * from nls_session_parameters; -- DD-MON-RR
alter session set nls_date_format = 'DD-MON-RR hh:mi:ss';

select sysdate as original_date, sysdate+1 as updated_date from dual; -- adds one day
select sysdate as original_date, sysdate + (1/24)*3 as updated_date from dual; -- can add hours this way
select sysdate as original_date, sysdate + interval '5' hour as updated_date from dual; -- adds hour
select sysdate as original_date, sysdate + interval '5' day as updated_date from dual; -- add days
select sysdate as original_date, sysdate + 1/(24*60*60) as updated_date from dual;

select sysdate as orginal, add_months(sysdate, 3) as Updated from dual;
select sysdate as orginal, add_months(sysdate, -12) as Updated from dual;


-- Practical on Functions in Oracle
-- insert the new sales with date = 2022-01-23 14:05:00 and other sales details for sales person 3 with any product
select * from as_sales;
insert into as_sales values(119,'C5', to_date('2022-01-23 14:05:00','yyyy-mm-dd hh24:mi:ss'),2,3,20,9.5);

-- display the details of all sales persons with all date in DD-MON-YYYY HH24:MI:SS
select * from as_sales_persons;
select sales_person_id,first_name,last_name,salary, 
to_char(joining_date,'DD-MON-YYYY HH24:MI:SS')joining,
to_char(leaving_date,'DD-MON-YYYY HH24:MI:SS')leaving_date,
to_char(dob,'DD-MON-YYYY HH24:MI:SS')dob
from as_sales_persons;

-- detail of all the sales persons currently working -- use joining and leaving date
select * from as_sales_persons
where leaving_date is null or leaving_date>current_timestamp;
--or
select * from as_sales_persons
where sysdate between joining_date and nvl(leaving_date, sysdate);
--or
select * from as_sales_persons
where sysdate between joining_date and coalesce(leaving_date, sysdate);

-- product base price - if even the price type = E and odd then price type = O with all product details
select * from as_products;
select product_id,product_name,price, --decode(price, 10,'E', (price/2)=1,'O', null,'Unknown', 'Default')price_type from as_products;
case mod(price,2)
when 0 then 'E'
when 1 then 'O'
else 'Default'
end pricetype from as_products;

insert into as_products values(6,'Toffee',5,'Asim',date '2025-05-24','T',sysdate);
commit;
select p.*,
case mod(price,2)
when 0 then 'Even'
when 1 then 'Odd'
else 'Default'
end price_type from as_products p;
--or
select p.*, decode(mod(price,2),0,'Even','Odd') price_type from as_products p;

-- Create the product code using fist and last character of the product.
select p.*, upper(substr(product_name,1,1) || substr(product_name,-1,1)) product_code from as_products p;

-- Sales date -- if sales done in JAN month then per unit price should be 10 rs extra.
select * from as_sales;
select s.*,
case extract(month from sale_date)
when 1 then price_per_unit+10
else price_per_unit
end as updated_for_Dec
from as_sales s;
--or
select s.*, to_char(sale_date,'MON'), 
case 
when to_char(sale_date,'MON') = 'DEC' then price_per_unit+10 
else price_per_unit end as new_price_for_jan from as_sales s;

-- sales date -- leaving persons - last 6 month sales - quantity should be half and price per unit should be doubled.
select * from as_sales;
select * from as_sales_persons;
select s.sale_id,s.sale_date,s.sales_person_id,s.quantity,s.price_per_unit,sp.first_name,sp.leaving_date, 
floor(months_between(leaving_date,sale_date)) last_sale_months_ago,
case
when floor(months_between(leaving_date,sale_date)) <= 6 then s.quantity/2
when floor(months_between(leaving_date,sale_date)) is null then null
else s.quantity
end as updated_quantity,
case
when floor(months_between(leaving_date,sale_date)) <= 6 then s.price_per_unit*2
when floor(months_between(leaving_date,sale_date)) is null then null
else s.price_per_unit
end as updated_ppu
from as_sales s join as_sales_persons sp on s.sales_person_id=sp.sales_person_id;

-- Sales person data to be displayed in two columns only -- sales person_id, firstname lastname - DOB(dd-mm/yyyy)
select sales_person_id, first_name ||' '|| last_name ||' - '|| to_char(dob,'dd-mm/yyyy') from as_sales_persons; -- Waqar Ali - 01-03/2000

-- Total sales in each year.
select * from as_sales;
select extract(year from sale_date), sum(quantity) from as_sales
group by extract(year from sale_date);

-- Sales date with age of the sales person at time of each sale
select s.*, trunc(months_between(sale_date,dob)/12) as age_at_saletime 
from as_sales s join as_sales_persons sp on s.sales_person_id = sp.sales_person_id;
