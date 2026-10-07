-- RECORD TYPE, TABLE BASED, USER DEFINED


-- TABLE BASED RT
-- Using the record type based on table, print the detail of the employee: Clerk(Firstname)
set SERVEROUTPUT on;
select * from as_employees;
declare
    V_RT_EMP AS_EMPLOYEES%ROWTYPE;
begin
    select * into v_rt_emp from as_employees where firstname = 'Zohaib';
    dbms_output.put_line('Emp_id : ' || V_RT_EMP.emp_id);
    dbms_output.put_line('FirstName : ' || V_RT_EMP.firstname);
    dbms_output.put_line('LastName : ' || V_RT_EMP.lastname);
    dbms_output.put_line('Dept_id : ' || V_RT_EMP.dept_id);
    dbms_output.put_line('Salary : ' || V_RT_EMP.salary);
end;
/


-- Using the record type based on table, fetch and print the data of lowest salaried employee with salary greater than 32000
select * from as_employees where salary > 32000 order by salary;
declare
    V_RT_EMP as_employees%rowtype;
begin
    select * into v_rt_emp from as_employees where salary > 32000 order by salary fetch first row only;
    dbms_output.put_line('Emp_id : ' || V_RT_EMP.emp_id);
    dbms_output.put_line('FirstName : ' || V_RT_EMP.firstname);
    dbms_output.put_line('LastName : ' || V_RT_EMP.lastname);
    dbms_output.put_line('Dept_id : ' || V_RT_EMP.dept_id);
    dbms_output.put_line('Salary : ' || V_RT_EMP.salary);
end;
/


-- Using the record type based on table, fetch the date of employee: Jimmy(f_name) and using the same record type
--      update only salary, lastname, dept_id of employee: Clerk(f_name)
select * from as_employees;
declare
    v_rt_emp as_employees%rowtype;
begin
    select * into v_rt_emp from as_employees where firstname = 'Jimmy';
    dbms_output.put_line('Emp_id : ' || V_RT_EMP.emp_id);
    dbms_output.put_line('FirstName : ' || V_RT_EMP.firstname);
    dbms_output.put_line('LastName : ' || V_RT_EMP.lastname);
    dbms_output.put_line('Dept_id : ' || V_RT_EMP.dept_id);
    dbms_output.put_line('Salary : ' || V_RT_EMP.salary);
    update as_employees set salary = v_rt_emp.salary, lastname = v_rt_emp.lastname, dept_id = v_rt_emp.dept_id where firstname = 'Clerk';
    dbms_output.put_line('Emp Clerk Updated..');
end;
/

-- OR
declare
    v_rt_emp as_employees%rowtype;
begin
    select * into v_rt_emp from as_employees where firstname = 'Jimmy';
    
    select emp_id,firstname into v_rt_emp.emp_id,v_rt_emp.firstname from as_employees where firstname = 'Clerk';
    
    update as_employees
    set row = v_rt_emp
    where firstname = 'Clerk';
    
    dbms_output.put_line('Emp Clerk Updated..');
end;
/
select * from as_employees where firstname in ('Jimmy','Clerk');
rollback;

-- Insert one record into department table using record type based on table.
declare
    v_rt_emp as_employees%rowtype;
begin
    v_rt_emp.emp_id := 1101;
    v_rt_emp.firstname := 'Loop';
    v_rt_emp.lastname := 'Hole';
    v_rt_emp.dept_id := 4;
    v_rt_emp.salary := 69000;
    
    insert into as_employees values v_rt_emp;
    commit;
    dbms_output.put_line('One Record Inserted Successfylly..');
end;
/

-- USER DEFINED
-- 1. Use the Record type to store the emp_id, dept_id and salry of an employee and print those detail of employee having highest salary.
set SERVEROUTPUT on;
select * from as_employees order by salary desc;

declare
    type TYP_EMP IS RECORD
    (
        empId as_employees.emp_id%type,
        deptId as_employees.dept_id%type,
        salry as_employees.salary%type
    );
    V_UDRT_EMP TYP_EMP;
begin
    select emp_id, dept_id, salary into V_UDRT_EMP from as_employees order by salary desc nulls last fetch first 1 row only;
    dbms_output.put_line('Emp_id : ' || V_UDRT_EMP.empId);
    dbms_output.put_line('deptId : ' || V_UDRT_EMP.deptId);
    dbms_output.put_line('salry : ' || V_UDRT_EMP.salry);
end;
/


-- 2. Using the user defined record type, fetch the details of highest salaried employee and 
--          update the salary, dept_id and lastname of it into te lowest salaried employee
declare
    type TYP_EMP IS RECORD
    (
        lastname as_employees.lastname%type,
        deptId as_employees.dept_id%type,
        salry as_employees.salary%type
    );
    V_UDRT_EMP TYP_EMP;
begin
    select lastname, dept_id, salary into V_UDRT_EMP from as_employees order by salary desc nulls last fetch first 1 row only;
    dbms_output.put_line('lastname : ' || V_UDRT_EMP.lastname);
    dbms_output.put_line('deptId : ' || V_UDRT_EMP.deptId);
    dbms_output.put_line('salry : ' || V_UDRT_EMP.salry);
    update as_employees
    set lastname=V_UDRT_EMP.lastname, dept_id=V_UDRT_EMP.deptId, salary=V_UDRT_EMP.salry
    where salary = (select min(salary) from as_employees);
    dbms_output.put_line('One row Updated..  ');
end;
/
rollback;

-- 3. Create the nested user defined record type to store empId, firstname, lastname and its departments detail
--      Store the data of the employee Zohaib(fName) into it and print all the details from the user defined record type
--          re-use the same record type to store and print the details of the employee Loop(fName)

declare
    type TYP_EMP IS RECORD
    (
        empId as_employees.emp_id%type,
        firstName as_employees.firstname%type,
        lastName as_employees.lastname%type,
        department as_departments%rowtype
    );
    V_UDRT_EMP TYP_EMP;
begin
    select 
    emp_id, 
    firstname, 
    lastname, 
    d.dept_id, 
    d.name, 
    d.city 
    into 
    V_UDRT_EMP.empId,
    V_UDRT_EMP.firstName,
    V_UDRT_EMP.lastName,
    V_UDRT_EMP.department.dept_id,
    V_UDRT_EMP.department.name,
    V_UDRT_EMP.department.city
    from as_employees e join as_departments d
    on e.dept_id = d.dept_id
    where firstname = 'Zohaib';
    
    dbms_output.put_line('EmpId : ' || V_UDRT_EMP.empId);
    dbms_output.put_line('FirstName : ' || V_UDRT_EMP.firstname);
    dbms_output.put_line('lastname : ' || V_UDRT_EMP.lastname);
    dbms_output.put_line('Dep ID : ' || V_UDRT_EMP.department.dept_id);
    dbms_output.put_line('Dep Name : ' || V_UDRT_EMP.department.name);
    dbms_output.put_line('Dep City : ' || V_UDRT_EMP.department.city);
    
    
    select 
    emp_id, 
    firstname, 
    lastname, 
    d.dept_id, 
    d.name, 
    d.city 
    into 
    V_UDRT_EMP.empId,
    V_UDRT_EMP.firstName,
    V_UDRT_EMP.lastName,
    V_UDRT_EMP.department.dept_id,
    V_UDRT_EMP.department.name,
    V_UDRT_EMP.department.city
    from as_employees e join as_departments d
    on e.dept_id = d.dept_id
    where firstname = 'Loop';
    
    dbms_output.put_line('------------------------------------------------');
    dbms_output.put_line('EmpId : ' || V_UDRT_EMP.empId);
    dbms_output.put_line('FirstName : ' || V_UDRT_EMP.firstname);
    dbms_output.put_line('lastname : ' || V_UDRT_EMP.lastname);
    dbms_output.put_line('Dep ID : ' || V_UDRT_EMP.department.dept_id);
    dbms_output.put_line('Dep Name : ' || V_UDRT_EMP.department.name);
    dbms_output.put_line('Dep City : ' || V_UDRT_EMP.department.city);
end;
/


-- ASSIGNMENT
-- 1.
declare 
    typ_TBRC as_employees%rowtype;
begin
    select * into typ_TBRC from as_employees order by salary desc nulls last offset 2 rows fetch first 1 row only;
    dbms_output.put_line('EmpId : ' || typ_TBRC.emp_id);
    dbms_output.put_line('FirstName : ' || typ_TBRC.firstname);
    dbms_output.put_line('lastname : ' || typ_TBRC.lastname);
    dbms_output.put_line('Dep ID : ' || typ_TBRC.dept_id);
    dbms_output.put_line('Dep Name : ' || typ_TBRC.salary);
    
    typ_TBRC.salary := typ_TBRC.salary+50;
    
    update as_employees
    set row = typ_TBRC
    where emp_id = typ_TBRC.emp_id;
    commit;
end;
/

select * from as_employees where emp_id = 1101;

-- 2. 
declare
    type TYP_EMP IS RECORD (
        empId       as_employees.emp_id%type,
        empName     as_employees.firstname%type,
        deptId      as_employees.dept_id%type,
        dept_name   as_departments.name%type
    );
    V_UDRC_EMP TYP_EMP;
begin
    select 
    emp_id,
    firstname,
    d.dept_id,
    d.name 
    into 
    V_UDRC_EMP.empId,
    V_UDRC_EMP.empName,
    V_UDRC_EMP.deptId,
    V_UDRC_EMP.dept_name 
    from as_employees e join as_departments d 
    on e.dept_id = d.dept_id 
    offset 3 rows 
    fetch first 1 row only;
    
    dbms_output.put_line('EmpId : ' || V_UDRC_EMP.empId);
    dbms_output.put_line('FirstName : ' || V_UDRC_EMP.empName);
    dbms_output.put_line('Dep ID : ' || V_UDRC_EMP.deptId);
    dbms_output.put_line('Dep Name : ' || V_UDRC_EMP.dept_name);
end;
/