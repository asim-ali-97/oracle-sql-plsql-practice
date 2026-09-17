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