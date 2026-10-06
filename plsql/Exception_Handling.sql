-- EXCEPTION HANDLING, RAISE, RAISE_APPLICATION_ERROR, OTHERS EXCEPTION


-- Exceptions 
-- NO_DATA_FOUND
-- TOO_MANY_ROWS 
-- INVALID_NUMBER 
-- OTHERS

-- Create a PL/sql block to fetch employee having firstname "Kendra" and show its salary, if not available then show the highest salary using exception.
select * from as_employees;
declare
    v_slry as_employees.salary%type;
begin
    select salary into v_slry from as_employees where lower(firstname) = lower('Kendra');
    dbms_output.put_line('salary of Kendra is : ' || v_slry);
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Inside NO_Data_Found exception..');
        select max(salary) into v_slry from as_employees;
        dbms_output.put_line('Max salry is : ' || v_slry);
    when TOO_MANY_ROWS then
        dbms_output.put_line('Inside TOO_MANY_ROWS exception...');
    when OTHERS then
        dbms_output.put_line('Inside Others exception : ');
end;
/
set SERVEROUTPUT on;


--create a pl/sql block to
    --fetch the highest salried emp of dep_id = 4 --> firstname
    -- if no emp for dep_id 4 then display dep_name of that dept and if no dept exist then
        -- create dept_id = 4  department having name "Production" and city "Sialkot"
select * from as_departments;
declare
    v_dept_name as_departments.name%type;
    v_firstname as_employees.firstname%type;
begin
    select firstname into v_firstname from as_employees where dept_id = 4 order by salary desc fetch first row only;
    dbms_output.put_line('Firstname of highest salried employee of dept id 4 is : ' || v_firstname);
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('NO employees Found for dept_id 4 : ' || '');
        begin
            select name into v_dept_name from as_departments where dept_id = 4;
            dbms_output.put_line('Department name of dept_id 4 is : ' || v_dept_name);
        exception
            when NO_DATA_FOUND then
                dbms_output.put_line('NO Department Found for dept_id 4 : ' || '');
                insert into as_departments values(4,'Production','Sialkot');
                commit;
                dbms_output.put_line('Dept_id 4 Added successfulyy ');
            when OTHERS then
                dbms_output.put_line('OTHER exception of the 2nd Exception : ');
        end;
    when OTHERS then
        dbms_output.put_line('OTHER exception of the 1st Exception : ');
end;
/
select * from as_employees;
update as_employees set dept_id = 4 where emp_id = 1024;
commit;




-- RAISE

-- Create user defined exception too_much_cost and assign -20333 code to it,
    -- if total salary of dept 'Admin' is greater than 30,000 then raise the too_much_cost exception and print suitable msg to handle the exception.
select * from as_departments;
set serveroutput on;
declare
    too_much_cost exception;
    PRAGMA exception_init(too_much_cost, -20333);
    v_total_salary number:=0;
begin
    select sum(salary) into v_total_salary from as_employees where dept_id = (select dept_id from as_departments where name = 'Admin');
    if v_total_salary > 30000 then 
        raise too_much_cost;
    end if;
exception
    when too_much_cost then 
        dbms_output.put_line('The total salary of the Admin department is higher than what was expected.... NEEDs Attention...!!');
        dbms_output.put_line('Error code is :  ' || sqlcode);
end;
/

-- If total employees having salary > 8000 are more than 10 then raise TOO_MANY_ROWS system exception and catch this exception with suitable msg.
    -- In continuatoin to it, if above exception is not thrown then only check for number of employees with salry > 5000,
    -- If it is more than 8 then raise user defined exception and handle it with proper msg and also with print error code of it.
select count(*)  from as_employees where salary > 8000;
select count(*) from as_employees where salary > 5000;
declare
    too_many_emp exception;
    pragma exception_init(too_many_emp,-20000);
    v_count number;
begin
    select count(*) into v_count from as_employees where salary > 8000;
    if v_count > 10 then
        raise too_many_rows;
    else
        select count(*) into v_count from as_employees where salary > 5000;
        if v_count > 8 then
            raise too_many_emp;
        end if;
    end if;
    dbms_output.put_line('Procedure ended without throwing any Exception.');
exception
    when TOO_MANY_ROWS then
        dbms_output.put_line('System Exception : Employee having salary more than 8000 are too many...');
    when too_many_emp then
        dbms_output.put_line('User-defined Exception : Employee having salary more than 5000 are too many...');
end;
/



-- RAISE_APPLICATION_ERROR 

declare
    v_num number := 100;
begin
    if v_num > 20 then 
        RAISE_APPLICATION_ERROR (-20010,'This is the 1st imp Error');
    end if;
exception
    when others then
        dbms_output.put_line('First IMP exception handled here..');
        RAISE_APPLICATION_ERROR (-20011,'This is the 2nd imp Error',true);
end;
/
set serveroutput on;



-- 1. Using RAISE_APPLICATION_ERROR, raise the application error if current second of the time is odd
--      if it is even then check for current miinute and if it is odd raise another error with RAISE_APPLICATION_ERROR
--      in both the cases error code and error msg should be different.
select to_char(sysdate, 'ss') from dual;
declare
    v_sec number:=0;
    v_min number:=0;
begin
    select to_char(sysdate, 'ss'), to_char(sysdate, 'mi') into v_sec, v_min from dual;
    dbms_output.put_line('curr sec : ' || v_sec || ' curr min : ' || v_min);
    if mod(v_sec,2) = 1 then
        RAISE_APPLICATION_ERROR(-20001,'ERROR : The Current Second was Odd..');
    elsif mod(v_min,2) = 1 then
        RAISE_APPLICATION_ERROR(-20099, 'err : Current minute of the time was Odd..');
    else
        dbms_output.put_line('Both Second and Minute of current time were even.. No Error Raised..');
    end if;
exception
    when others then
        dbms_output.put_line('RAISE_APPLICATION_ERROR handled successfully..');

end;
/


-- 2. If total slary of HR department is greater then IT department
--    then raise error with "HR > IT" error and code should be -20400
--    else raise "IT > HR" error and code should be -20500
select * from as_departments;
select * from as_employees;
select sum(salary) from as_employees where dept_id = (select dept_id from as_departments where name = 'HR');
select sum(salary) from as_employees where dept_id = (select dept_id from as_departments where name = 'IT');

declare
    v_hr_slry number := 0;
    v_it_slry number := 0;
begin
--    select sum(salary) into v_hr_slry from as_employees where dept_id = (select dept_id from as_departments where name = 'HR');
--    select sum(salary) into v_it_slry from as_employees where dept_id = (select dept_id from as_departments where name = 'IT');

    select sum(case when name = 'HR' then salary end), sum(case when name = 'IT' then salary end) 
    into v_hr_slry, v_it_slry from as_employees e join as_departments d on e.dept_id = d.dept_id
    where d.name in('HR','IT');
    
    if v_hr_slry > v_it_slry then
        raise_application_error(-20400,'HR > IT');
    elsif v_it_slry > v_hr_slry then
        raise_application_error(-20500,'IT > HR');
    elsif v_it_slry = v_hr_slry then  
        dbms_output.put_line('HR and IT total salaries are Equal.. ');
    else
        raise_application_error(-20999,'Something went wrong..');
    end if;

end;
/


-- OTHERS EXCEPTION
declare
    v_empid number;
begin
    select emp_id into v_empid from as_employees;
exception
    when others then
        dbms_output.put_line('SQL_CODE' || sqlcode);
        dbms_output.put_line('SQL_ERRM: ' || sqlerrm);
end;
/

declare
    v_empid number;
    v_ud_exc exception;
begin
    raise v_ud_exc;
exception
    when others then
        dbms_output.put_line('SQL_CODE: ' || sqlcode);
        dbms_output.put_line('SQL_ERRM: ' || sqlerrm);
end;
/

declare
    v_empid number;
    v_ud_exc exception;
    pragma exception_init(v_ud_exc, -20023);
begin
    raise v_ud_exc;
exception
    when others then
        dbms_output.put_line('SQL_CODE: ' || sqlcode);
        dbms_output.put_line('SQL_ERRM: ' || sqlerrm);
end;
/

declare
    v_empid number;
    v_ud_exc exception;
    pragma exception_init(v_ud_exc, -20023);
begin
    raise_application_error(-20001,'this is appllication error msg');
exception
    when others then
        dbms_output.put_line('SQL_CODE: ' || sqlcode);
        dbms_output.put_line('SQL_ERRM: ' || sqlerrm);
end;
/

--1. Try to fetch emp_id and name of the emp having salary 1500 using sigle variable if error occurs then handle it through OTHERS  and print 
--      useful details regarding the error (type of err, internal err msg)
set serveroutput on;
select * from as_employees;

declare
    v_emp_id as_employees.emp_id%type;
    v_emp_name as_employees.firstname%type;
begin
    select emp_id,firstname into v_emp_id,v_emp_name from as_employees where salary = 1500;
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/


-- Try to divide the current minute with last digit of current second and if error then handle with OTHERS with useful info
declare 
    v_sec number:=to_char(sysdate,'ss');
    v_min number:=to_char(sysdate,'mi');
    v_result number:= 0;
begin
--  v_sec := v_sec - trunc(v_sec/10)*10;
    v_sec := mod(v_sec,10);
    dbms_output.put_line('Operation will be : ' || v_min || ' / ' || v_sec);
    v_result := trunc(v_min/v_sec,2);
    dbms_output.put_line('Result is : ' || v_result);
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
    
end;
/


-- Create a user defined exception and attach error code with it. Raise the exception if Department id 4 has more than 4 employees in it
--      handle the error using others
declare
    v_ud_exc exception;
    pragma exception_init(v_ud_exc, -20099);
    v_count number:= 0;
begin
    select count(1) into v_count from as_employees where dept_id = 4;
    if v_count < 4 then
        raise v_ud_exc;
    end if;

exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/


-- Try to delete dept_id = 1, from department talbe, and if any error then handke it gracefully and print all the details about error
set serveroutput on;
begin
    delete from as_departments where dept_id = 1;
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/

-- If total records in department and employees is greater than 17 then raise_application_error with code and msg
--     and print msg and code in exception block.
declare
    v_emp_cnt number:= 0;
    v_dep_cnt number:= 0;
begin
    select count(*) into v_emp_cnt from as_employees;
    select count(*) into v_dep_cnt from as_departments;
    dbms_output.put_line(' '||v_emp_cnt||'  ---  '||v_dep_cnt);
    if v_emp_cnt+v_dep_cnt > 17 then
        raise_application_error(-20001,'error : total count is greater than 17.');
    end if;
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/


-- ASSIGNMENT
-- take v_salary = 8100, and fetch emp_id, name, salary, manager_id from employees table using salary > v_salary condition.
--      handle the exception, if raised any using EXCEPTION block use NO_DATA_FOUND and TOO_MANY_ROWS exception handle block and print appropriate error msg;
select emp_id, firstname, salary from as_employees where salary > 8100;
declare
    v_salary number := 8100;
    v_empid as_employees.emp_id%type;
    v_name as_employees.firstname%type;
    v_slary as_employees.salary%type;
begin
    select emp_id, firstname, salary into v_empid,v_name,v_slary from as_employees where salary > v_salary;

exception
    when NO_DATA_FOUND THEN
        dbms_output.put_line('INSIDE NO_DATA_FOUND');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
    when TOO_MANY_ROWS THEN
        dbms_output.put_line('INSIDE TOO_MANY_ROWS');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/


-- Try to assign the date in wrong format to a date variable and check the SQLCODE and SQLERRM message thrown by oracle.
declare
    v_date date;
begin
    v_date := to_date('2022-12-23','dd-mm-yyyy');
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/


-- Declare three variables and assign one variable the value var1/var2, try to assing 0 to var2 and handle and check the err details.
declare
    var1 number := 2;
    var2 number := 0;
    var3 number := 0;
begin 
    var3 := var1/var2;
    dbms_output.put_line('var3 = ' || var3);
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/


-- Try to update the varchar value to number column of employees table and check the error details.
select * from as_employees;
begin
    update as_employees set emp_id = 'abc' where emp_id = 1011;
exception
    when others then
        dbms_output.put_line('INSIDE Others');
        dbms_output.put_line('SQL_CODE : ' || SQLCODE);
        dbms_output.put_line('SQL_ERR_MSG : ' || SQLERRM);
end;
/
