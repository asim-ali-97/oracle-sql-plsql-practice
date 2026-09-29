-- SYNONYMS

-- alternative name of object ie table, view, sequence, procedure etc
-- mostly used when object of another schema are needed to be accesed

create or replace synonym as_emp for as_employees;
select * from as_employees;
select * from as_emp; -- using synonym

--let say we have two schemas asim and asim_1, and employees table is object of user asim

-- asim
grant select on employees to asim_1; -- grant succeeded
grant select on employyes to public; -- every user can select from employees

-- asim_1
select * from employees; -- err-> table or view does not exist
select * from asim.employees; -- working

create or replace synonym employees_1 for asim.employees; -- synonym EMPLOYEES_1 created
select * from employees_1;

-- NOTE => before creating synonym must check first if that is accessable or not.
-- ie 
select * from user_views;
select * from asim.VW_SALE_SECOND_HALF_OF_YEAR; -- if accessible then
create or replace synonym years_scnd_half_sale for asim.VW_SALE_SECOND_HALF_OF_YEAR;
select * from years_scnd_half_sale;
