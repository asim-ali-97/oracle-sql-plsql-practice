-- COMMON TABLE EXPRESSION (CTE), HIERARCHICAL QUERY CLAUSE, DISTINCT, DEFAULT IN CONVERSION FUNCTION, LIKE, MULTIPLE INSERTS, CONDITIONAL AGGREGATION, TRANSPOSING COLUMN AND ROWS


-- Looping using CTE
with Series(my_number) as (
    -- Anchor member
    select 
    1 as my_number from dual
    union all
    -- Recursive member
    select
    my_number + 1
    from Series
    where my_number < 20
)
select * from Series;

select add_months(trunc(sysdate,'year'),12) - trunc(sysdate, 'year') from dual; -- 365

select trunc(sysdate) + level -1 as days_from_now from dual
connect by trunc(sysdate) + level <= add_months(trunc(sysdate),12);

select level from dual
connect by level + 1 <= 20;

-- Show the employee hirerarchy by displaying each employee's level withing the organization
select * from as_sales_persons;
with CTE_Emp_Hierarchy(sales_person_id,first_name,manager_id,h_level) as 
(
    select
        sales_person_id,
        first_name,
        manager_id,
        1 as h_level 
    from as_sales_persons
    where manager_id is null
    union all
    select
        sp.sales_person_id,
        sp.first_name,
        sp.manager_id,
        h_level + 1
    from as_sales_persons sp
    inner join CTE_Emp_Hierarchy
    on sp.manager_id =  CTE_Emp_Hierarchy.sales_person_id
    
)
select * from CTE_Emp_Hierarchy;



-- Hierarchical Query Clause
select * from as_sales_persons;
select 
    sales_person_id,
    concat(concat(first_name,' '),last_name),
    manager_id,
    prior concat(concat(first_name,' '),last_name) as manager,
    level
from as_sales_persons
start with manager_id is null
connect by manager_id = prior sales_person_id
order by manager_id nulls first;

select
    sales_person_id,
    first_name,
    last_name,
    salary,
    prior first_name,
    prior last_name,
    prior salary
from as_sales_persons
start with manager_id is null
connect by manager_id = prior sales_person_id
order by sales_person_id;


-- DISTINCT
select * from as_employees;
select distinct firstname, lastname from as_employees;
select distinct dept_id from as_employees order by dept_id;
select * from as_sales_persons;
select distinct manager_id from as_sales_persons order by manager_id;
select distinct manager_id,first_name from as_sales_persons where manager_id is not null order by manager_id;
select distinct case when salary > 350000 then 1 else 0 end from as_sales_persons;


-- DEFAULT IN CONVERSION FUNCTION  -- doesnt works with us cux our db is 12c, works in higher versions
select to_number('234') from dual;
select to_number('234' default 222 on conversion error) from dual;

select to_date('2022-11-14','YYYY-MM-DD') from dual;
select to_date('2022-11-14' default date '2022-11-14' ON CONVERSION ERROR ,'YYYY-MM-DD') from dual;
select validate_conversion('234' as number) from dual;


-- LIKE
select * from as_employees;

select 
* 
from as_employees
where lastname like '%i%';

select
*
from as_employees
where salary like '____'; -- only 4 digit salaries will be shown

select
*
from as_employees
where upper(lastname) like '%E_A%';

select 
* 
from all_tables
where table_name like 'AS%';

select
*
from all_tables
where table_name like 'AS\_%' escape '\';

select
*
from all_tables
where table_name like '__\_%' escape '\';



-- MULTIPLE INSERTS --> INSERT ALL, INSERT FIRST
select * from as_employees;
select * from as_departments;

--> INSERT ALL --> Unconditional Insert All, Conditional Insert All

--> Unconditional Insert All
-- Static Data
insert all 
into as_departments (dept_id, name, city) values (4,'Sales','Lahore')
into as_employees values(1101,'Naveed','Shekh',3,45500)
select * from dual;  -- Driving Query
rollback;

-- Success
insert all 
into as_departments (dept_id, name, city) values (4,'Sales','Lahore')
into as_employees values(1101,'Naveed','Shekh',4,45500)
into as_employees values(1102,'Hameed','Gul',4,55500)
select * from dual;
select * from as_employees;
rollback;

-- Error
insert all 
into as_employees values(1101,'Naveed','Shekh',4,45500)
into as_departments (dept_id, name, city) values (4,'Sales','Lahore')
into as_employees values(1102,'Hameed','Gul',4,55500)
select * from dual;
select * from as_employees;
rollback;

-- inserting throuhg driving query
insert all 
into as_departments (dept_id, name, city) values (department_id,department_name,department_city)
into as_employees values(employee_id,fname,lname,dept_id,salary)
    select 4 as department_id, 'Sales' as department_name, 'Lahore' as department_city,
    1101 as employee_id, 'Naveed' fname, 'Shekh' lname, 4 dept_id, 45500 salary 
from dual;
rollback;


--> Conditional Insert All
insert all
when salary >= 45500 then
into as_departments (dept_id, name, city) values (department_id,department_name,department_city)
when salary <= 45500 then
into as_employees values(employee_id,fname,lname,dept_id,salary)
    select 4 as department_id, 'Sales' as department_name, 'Lahore' as department_city,
    1101 as employee_id, 'Naveed' fname, 'Shekh' lname, 4 dept_id, 45500 salary 
from dual;
rollback;


-- INSERT FIRST
insert first
when salary >= 45500 then
into as_departments (dept_id, name, city) values (department_id,department_name,department_city)
when salary <= 45500 then
into as_employees values(employee_id,fname,lname,dept_id,salary)
    select 4 as department_id, 'Sales' as department_name, 'Lahore' as department_city,
    1101 as employee_id, 'Naveed' fname, 'Shekh' lname, 4 dept_id, 45500 salary 
from dual;
select * from as_departments;
select * from as_employees;
rollback;

insert first
when salary > 45500 then
into as_departments (dept_id, name, city) values (department_id,department_name,department_city)
when salary <= 45500 then
into as_employees values(employee_id,fname,lname,department_id-1,salary)
    select 4 as department_id, 'Sales' as department_name, 'Lahore' as department_city,
    1101 as employee_id, 'Naveed' fname, 'Shekh' lname, 45500 salary 
from dual;
select * from as_departments;
select * from as_employees;
rollback;

insert first
when salary > 45500 then
into as_departments (dept_id, name, city) values (department_id,department_name,department_city)
else
into as_employees values(employee_id,fname,lname,department_id-1,salary)
    select 4 as department_id, 'Sales' as department_name, 'Lahore' as department_city,
    1101 as employee_id, 'Naveed' fname, 'Shekh' lname, 45500 salary 
from dual;
select * from as_departments;
select * from as_employees;
rollback;



-- CONDITIONAL AGGREGATION
select * from as_employees;

select count(*), min(salary) from as_employees where salary > 5000; -- it wont give the correct total count from the table thats why we use conditioal aggegrate
select count(*), min(case when salary > 5000 then salary end) from as_employees;


select * from as_sales;

select
    count(*),
    count(case when sale_date between add_months(trunc(sysdate, 'year'), -36) and add_months(trunc(sysdate, 'year'), -24)-1 then 1 end) as sl_fr_23_to_24,
    count(case when sale_date between add_months(trunc(sysdate, 'year'), -24) and add_months(trunc(sysdate, 'year'), -12)-1 then 1 end) as sl_fr_24_to_25,
    count(case when sale_date between add_months(trunc(sysdate, 'year'), -12) and trunc(sysdate, 'year') then 1 end) as sl_fr_25_to_26,
    count(case when sale_date between trunc(sysdate, 'year') and sysdate then 1 end) as sl_fr_26_to_date
from as_sales;


-- TRANSPOSING COLUMN AND ROWS

-- Pivot
create table AS_STUDENT_RESULTS (
    STUDENT_NAME VARCHAR2(100),
    SUBJECT_NAME VARCHAR2(100),
    MARKS NUMBER
);

insert into AS_STUDENT_RESULTS values('Faizan','Maths',80);
insert into AS_STUDENT_RESULTS values('Faizan','Physics',70);
insert into AS_STUDENT_RESULTS values('Faizan','Chemistry',73);
insert into AS_STUDENT_RESULTS values('Nasir','Maths',87);
insert into AS_STUDENT_RESULTS values('Nasir','Physics',88);
insert into AS_STUDENT_RESULTS values('Nasir','Chemistry',81);
insert into AS_STUDENT_RESULTS values('Mustansir','Maths',60);
insert into AS_STUDENT_RESULTS values('Mustansir','Physics',72);

commit;

select * from AS_STUDENT_RESULTS;

select * from 
    (select * from AS_STUDENT_RESULTS)
    pivot
    (
        sum(marks)
        for subject_name in ('Maths' as math_marks,'Physics' as physics_marks,'Chemistry' as chemistry_marks)
    );

insert into AS_STUDENT_RESULTS values('Faizan','Maths',10);
insert into AS_STUDENT_RESULTS values('Nasir','Physics',7);
commit;

select * from AS_STUDENT_RESULTS;

select * from 
    (select * from AS_STUDENT_RESULTS)
    pivot
    (
        max(marks) --min(marks) --sum(marks)
        for subject_name in ('Maths' as math_marks,'Physics' as physics_marks,'Chemistry' as chemistry_marks)
    );


-- Using Conditional Aggregate for transposing
select student_name,
    sum(marks)          -- this will give the sum of marks of subs for each std
from AS_STUDENT_RESULTS
group by student_name;

select student_name,        -- we are using pivot becz that is simpler we dont have to use multible conditional aggregate func there, we just have to put the name in the IN list
    sum(case when subject_name = 'Maths' then marks end) as math_marks,
    sum(case when subject_name = 'Physics' then marks end) as physics_marks,
    sum(case when subject_name = 'Chemistry' then marks end) as chemistry_marks
from AS_STUDENT_RESULTS
group by student_name;

-- diff b/w pivot and cond aggreg
select * from 
    (select * from AS_STUDENT_RESULTS)
    pivot
    (
        max(marks) as mx , min(marks) mn, sum(marks) sm
        for subject_name in ('Maths' as math_marks,'Physics' as physics_marks,'Chemistry' as chemistry_marks)
    );

select student_name,
    sum(case when subject_name = 'Maths' then marks end) as math_marks,
    min(case when subject_name = 'Physics' then marks end) as physics_marks,
    max(case when subject_name = 'Chemistry' then marks end) as chemistry_marks
from AS_STUDENT_RESULTS
group by student_name;

-- in the above example it is clear that the conditional aggregate gives us more flexibility, 
--when we use pivot and use different aggr func (sum, min, max) then it will generate three records(min, max, sum) 
--for each subject while in conditional we it will generate only one column for each
-- So we have to choose smartly according to our usecase


-- Unpivot
create table student_marks_in_one_row as
select * from 
    (select * from AS_STUDENT_RESULTS)
    pivot
    (
        sum(marks)
        for subject_name in ('Maths' as math_marks,'Physics' as physics_marks,'Chemistry' as chemistry_marks)
    );

select * from student_marks_in_one_row;
select * from student_marks_in_one_row
unpivot
(
    marks
    for subject in 
        (
        MATH_MARKS as 'Maths',
        PHYSICS_MARKS as 'Physics',
        CHEMISTRY_MARKS as 'Chemistry'
        )
);

select * from student_marks_in_one_row
unpivot include nulls
(
    marks
    for subject in 
        (
        MATH_MARKS as 'Maths',
        PHYSICS_MARKS as 'Physics',
        CHEMISTRY_MARKS as 'Chemistry'
        )
);

-- doing the same as unpivot using union all which is way simpler but gets lengthy when number of columns are more
select * from student_marks_in_one_row;

select student_name, 'Maths' as subject_name, math_marks as marks from student_marks_in_one_row
union all
select student_name, 'Physics' as subject_name, physics_marks as marks from student_marks_in_one_row
union all
select student_name, 'Chemistry' as subject_name, chemistry_marks as marks from student_marks_in_one_row
order by student_name,subject_name;


select * from user_constraints;
select * from user_constraints where r_constraint_name = 'PK_AS_DEPARTMENTS';

select * from user_cons_columns where constraint_name = 'PK_AS_DEPARTMENTS';