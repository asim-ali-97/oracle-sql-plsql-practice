-- VARIABLE DECLARATION, VARIABLE ASSIGNMENT, CONDITIONALS(IF, IF ELSE, ELSIF), CASE STATEMENT, GOTO

--Practical on variables

-- Declare a variable v_num_days as number
-- Declare one variable v_num_months as number and default value as 3
-- Declare one variable v_birthdate as date and make it not null, default value should be 2001-04-09
-- Try to update the v_birthdate to null and check the result -- comment out the code after you have checked the error
-- Create one constant as v_pi_value and default it using assignment operator to 3.14
-- Create the variable to store id, name and city of the department
-- Make ID as constant with value = 1, and department city as not null and initialize it with 'Lahore'

DECLARE
    v_num_days NUMBER;
    v_num_months number default 3;
    v_birthdate date not null default date '2001-04-09';
    v_pi_value CONSTANT NUMBER(3,2) := 3.14;
    V_DEPT_ID CONSTANT AS_DEPARTMENTS.dept_id%type := 1;
    V_DEPT_NAME AS_DEPARTMENTS.name%type;
    V_DEPT_CITY AS_DEPARTMENTS.city%type not null := 'Lahore';
    
    
BEGIN
--    dbms_output.put_line('V_NUM is = ' ||  V_NUM);
--    v_birthdate := null;        
    null;
end;
/

set serveroutput on;
-- VARIABLE ASSIGNMENT
DECLARE
    v_num number;
    v_emp_id as_employees.emp_id%type;
    v_firstname as_employees.firstname%type;
BEGIN
    v_num := 1;
    v_num := 1+1+1;
    v_num := v_num + 1;
    dbms_output.put_line('v_num is ' || v_num);
    select emp_id into v_emp_id from as_employees where salary = 55000;
    dbms_output.put_line('v_emp_id is ' || v_emp_id);
    select emp_id, firstname into v_num, v_firstname from as_employees where salary = 55000;
    dbms_output.put_line('v_num is ' || v_num || ' and v_firstname is ' || v_firstname);
END;
/



-- Practicals on Variable Assignment
declare
    v_num_days NUMBER;
    v_num_months number default 3;
    v_birthdate date not null default date '2001-04-09';
    v_pi_value CONSTANT NUMBER(3,2) := 3.14;
    V_DEPT_ID CONSTANT AS_DEPARTMENTS.dept_id%type := 1;
    V_DEPT_NAME AS_DEPARTMENTS.name%type;
    V_DEPT_CITY AS_DEPARTMENTS.city%type not null := 'Lahore';
begin
    -- Add 2 months to the existing v_bithdate and assgn it back to v_birthdate
    dbms_output.put_line('Original birthdate --> ' || v_birthdate);
    v_birthdate := add_months(v_birthdate,2);
    dbms_output.put_line('updated birthdate --> ' || v_birthdate);
    -- Assign the name of the dept and city having max dept_id in the dept table
    select name,city into v_dept_name, v_dept_city from as_departments order by dept_id desc fetch first row only;
    dbms_output.put_line('updated dept --> ' || v_dept_name || ' ' || v_dept_city);
    -- Assign the month and date of the existing value of v_birthdate to v_num_days and v_num_months
    dbms_output.put_line('Birthdate --> ' || v_birthdate);
    v_num_months := extract(month from v_birthdate);
    v_num_days := extract(day from v_birthdate);
    dbms_output.put_line('v_birthdate MONth --> ' || v_num_months || ' v_birthdate date ' || v_num_days);
    v_num_months := to_char(v_birthdate,'mm');
    v_num_days := to_char(v_birthdate, 'dd');
    dbms_output.put_line('v_birthdate MONth --> ' || v_num_months || ' v_birthdate date ' || v_num_days);
end;
/
select * from as_departments;
select * from as_departments order by dept_id desc fetch first row only;



declare
    v_salary as_employees.salary%type;
    v_half_salary_count number :=10;
    v_max_half_salary as_employees.salary%type;
    v_emp_id as_employees.emp_id%type;
    v_firstname as_employees.firstname%type;
begin
    select max(salary) into v_salary from as_employees;
    dbms_output.put_line('Max Salry ==> ' || v_salary);
    select count(*) into v_half_salary_count from as_employees where salary <= v_salary/2;
    dbms_output.put_line('Less than Half Salry count ==> ' || v_half_salary_count);
    select max(salary) into v_max_half_salary from as_employees where salary <= v_salary/2;
    dbms_output.put_line('Max in Less than Half Salry ==> ' || v_max_half_salary);
    select emp_id, firstname into v_emp_id, v_firstname from as_employees where salary = v_max_half_salary;
    dbms_output.put_line('Max in Less than Half Salry emp_id ==> ' || v_emp_id);
    dbms_output.put_line('Max in Less than Half Salry First_Name ==> ' || v_firstname);
    update as_employees set salary = salary - 1
    where salary = v_max_half_salary;
    rollback;
end;
/
select * from as_employees;



-- Assignment; working with variables

-- Declare one variable v_lucky_number
-- Count total number of departments and assign it to v_lucky_number variable
-- Multiply salary and emp_id and take the third last digit from that value and order employees according to that number in decending order.
--      take first v_lucky_number employees from that ordered employeees and update their salary by v_lucky_number percent

declare
    v_lucky_number NUMBER;
begin
    select count(*) into v_lucky_number from as_departments;
    dbms_output.put_line('v_lucky_number : ' || v_lucky_number);
    update as_employees set salary = salary + (salary * v_lucky_number/100) 
    where salary in (select salary 
    from as_employees 
    order by substr(salary*emp_id,-3,1) desc 
    fetch first 3 rows only);

end;
/
select * from as_employees;
select * from as_employees order by substr(salary*emp_id,-3,1) desc fetch first 3 rows only;
rollback;

--ASIM     null
--Clerk    7800     8034
--Navid    45200    46556


declare
    v_count number;
begin
    select count(*) into v_count from as_sales_persons where manager_id is null;
    dbms_output.put_line('v_count is --> ' || v_count);
end;
/
select * from as_sales_persons;


select * from as_employees;
declare
    V_EMPID as_employees.emp_id%type := 1101;
    V_FIRSTNAME as_employees.firstname%type;
    V_LASTNAME as_employees.lastname%type;
    V_DEPT_ID as_employees.dept_id%type := 3;
    V_SALARY as_employees.salary%type;
begin
    V_FIRSTNAME := 'John';
    V_LASTNAME := 'Elia';
    V_SALARY := 110000;
    insert into as_employees values(V_EMPID,V_FIRSTNAME,V_LASTNAME,V_DEPT_ID,V_SALARY);
end;
/


-- Assignment IF Statement

-- declare one variable v_current_seconds, initialize it with current second (using current time) if v_current_seconds is above 30
-- then update all odd employee_ids salry by 299.
set serveroutput on;
declare
    v_current_seconds number := 10;
begin
    select to_char(sysdate,'ss') into v_current_seconds from dual;
    dbms_output.put_line('v_current_seconds = ' || v_current_seconds);
    IF v_current_seconds > 30 THEN
        update as_employees set salary = salary+299 where mod(emp_id,2) = 1;
        dbms_output.put_line('Salary of employees with Odd ids has been updated...');
    END IF;
end;
/
rollback;


--Declare one variable v_current_seconds. Initialize it with current second (using current time)
--If v_current_seconds is between 50-59 then then print highest earning employee id and name.
--If v_current_seconds is between 40-49 then then print 3rd highest earning employee id and name.
--If v_current_seconds is between 30-39 then then print 5th highest earning employee id and name.
--If v_current_seconds is between 20-29 then then print lowest earning employee id and name.
--else print "no data"
set SERVEROUTPUT on;
declare 
    v_current_seconds number;
    v_id as_employees.emp_id%type;
    v_name as_employees.firstname%type;
    
begin
    v_current_seconds := to_char(sysdate,'ss');
    dbms_output.put_line('v_current_seconds = ' || v_current_seconds);
    
    if v_current_seconds between 50 and 59 then
        select emp_id, firstname 
        into v_id, v_name 
        from as_employees 
        where salary is not null 
        order by salary desc
        fetch first row only;
        dbms_output.put_line('id of highest salaried person is ' || v_id || ' and name is ' || v_name);
        
    elsif v_current_seconds between 40 and 49 then
        select emp_id, firstname 
        into v_id, v_name 
        from as_employees 
        where salary = (select salary from as_employees
        where salary is not null
        group by salary
        order by salary desc
        OFFSET 2 rows
        fetch first row only);
        dbms_output.put_line('id of  3rd highest salaried person is ' || v_id || ' and name is ' || v_name);
        
    elsif v_current_seconds between 30 and 39 then
        select emp_id, firstname 
        into v_id, v_name 
        from as_employees 
        where salary = (select salary from as_employees
        where salary is not null
        group by salary
        order by salary desc
        OFFSET 4 rows
        fetch first row only);
        dbms_output.put_line('id of  5th highest salaried person is ' || v_id || ' and name is ' || v_name);
        
    elsif v_current_seconds between 20 and 29 then
        select emp_id, firstname 
        into v_id, v_name 
        from as_employees
        where salary is not null 
        order by salary
        fetch first row only;
        dbms_output.put_line('id of Lowest salaried person is ' || v_id || ' and name is ' || v_name);
        
    else
        dbms_output.put_line('No Data');
        
    end if;
end;
/


-- CASE STATEMENT
set serveroutput on;
declare
    v_num number := 23;
begin
    case mod(v_num, 2)
        when 0 then dbms_output.put_line(v_num || ' is Even');
        when -1 then dbms_output.put_line('Invalid Condition...');
        else dbms_output.put_line(v_num || ' is Odd');
    end case;
    
    case
        when mod(v_num,5) = 0 then
            dbms_output.put_line(v_num || ' is Divisible by 5');
        when mod(v_num,4) = 0 then
            dbms_output.put_line(v_num || ' is Divisible by 4');
        when mod(v_num,3) = 0 then
            dbms_output.put_line(v_num || ' is Divisible by 3');
        when mod(v_num,2) = 0 then
            dbms_output.put_line(v_num || ' is Divisible by 2');
        else
            dbms_output.put_line(v_num || ' is not Divisible by any number less than 5');
    end case;
end;
/



--Practical on case statement

--Update statement to update employee/department.
--take any one random employee. take emp_id as constant.
--Update the salary of employee to 10000 if name of the employee is between A-G,
--else if department id is odd then update its department's city to Kochi
--else update salary of that department's employee to 1500

DECLARE
    V_EMP_ID CONSTANT AS_EMPLOYEES.EMP_ID%TYPE := 1015;
    V_NAME AS_EMPLOYEES.FIRSTNAME%TYPE;
    V_DEPT_ID AS_EMPLOYEES.DEPT_ID%TYPE;
BEGIN
    select firstname,dept_id into V_NAME,V_DEPT_ID from as_employees where emp_id = V_EMP_ID;
    dbms_output.put_line('Employee name is : ' || V_NAME || ' and Dept_id is : ' || V_DEPT_ID);
    case
        when V_NAME BETWEEN 'A' and 'G' then
            update as_employees set salary = 10000 where emp_id = V_EMP_ID;
            dbms_output.put_line('Employee name is BETWEEN A and G. salary updated to 10000');
        when mod(V_DEPT_ID,2) = 1 then
            update as_departments set city = 'Peshawar' where dept_id = V_DEPT_ID;
            dbms_output.put_line('Employee DEPT ID is ODD and dept city was updated to Peshawar');
        else
            update as_employees set salary = 1500 where dept_id = V_DEPT_ID;
            dbms_output.put_line('Employees salary was updated to 1500');
    end case;
END;
/
rollback;
SELECT * FROM AS_EMPLOYEES;
select * from as_departments;


--Take one number in variable
--add following number to the variable
--4 if number is two digit
--10 if number is three digit
--23 if number is four digit
--55 for all other
declare
    v_num number := 1;
begin
    case length(v_num)
        when 2 then v_num := v_num + 4;
        when 3 then v_num := v_num + 10;
        when 4 then v_num := v_num + 23;
        else v_num := v_num + 55;
    end case;
    dbms_output.put_line(v_num );
end;
/



-- GOTO 

-- Using goto print 1 to 10
set serveroutput on;
declare
    v_num number := 1;
begin
    <<start_again>>
    if v_num <= 10 then
        dbms_output.put_line('v_num ===> ' || v_num );
        v_num := v_num + 1;
        goto start_again;
    end if;
end;
/

--Assignment
-- create a pl/sql block to take the count of employees having "A"(case sensitive) and if count is odd then print the count of the employees.
declare
    v_count number;
begin
    select count(*) into v_count from as_employees where firstname like('A%');
    if mod(v_count,2) = 0 then
        dbms_output.put_line('v_count ===> ' || v_count );
    else
        dbms_output.put_line('Count is Odd.');
    end if;
end;
/

-- create a pl/sql block to check if the current minute is divisible by current hour, if yes, 
--assign YES to a variable else assign NO to it using CASE WHEN.
set serveroutput on;
declare
    v_min number;
    v_hour number;
    v_divisible varchar2(3);
begin
    select to_char(sysdate, 'hh'), to_char(sysdate, 'mi') into v_hour,v_min from dual;
    dbms_output.put_line('v_min ===> ' || v_min || ' v_hour ==> ' || v_hour );
    case
        when mod(v_min,v_hour) = 0 then
            v_divisible := 'YES';
        else
            v_divisible := 'NO';
    end case;
    dbms_output.put_line('v_divisible ===> ' || v_divisible );
end;
/

select to_char(sysdate, 'hh') from dual;
select to_char(sysdate, 'mi') from dual;