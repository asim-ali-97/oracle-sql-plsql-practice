-- CURSOR, PARAMETARISED CURSOR, CURSOR IN FOR LOOP

-- DECLARE --> OPEN --> FETCH --> CLOSE

-- CURSOR ATTRIBUTES 
-- %ISOPEN, %FOUND, %NOTFOUND, %ROWCOUNT 



declare
    CURSOR C_EMP IS SELECT * FROM AS_EMPLOYEES ORDER BY EMP_ID;
    V_DATA C_EMP%ROWTYPE;
BEGIN
    OPEN C_EMP;
    DBMS_OUTPUT.PUT_LINE('C_EMP%ROWCOUNT BEFORE FETCH IS : ' || C_EMP%ROWCOUNT);
    DBMS_OUTPUT.PUT_LINE('BEFORE FIRST FETCH  :  ' || CASE WHEN C_EMP%FOUND THEN 'FOUND IS TRUE' WHEN C_EMP%FOUND IS NULL THEN 'FOUND IS NULL' ELSE 'FOUND IS FALSE' END);
    LOOP
        FETCH C_EMP INTO V_DATA;
        DBMS_OUTPUT.PUT_LINE(CASE WHEN C_EMP%FOUND THEN 'FOUND IS TRUE' ELSE 'FOUND IS FALSE' END);
        EXIT WHEN C_EMP%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('C_EMP%ROWCOUNT IS : ' || C_EMP%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE(V_DATA.EMP_ID || ' | ' || V_DATA.FIRSTNAME || ' | ' || V_DATA.LASTNAME || ' | ' || V_DATA.DEPT_ID || ' | ' || V_DATA.SALARY);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CASE WHEN C_EMP%ISOPEN THEN 'C_EMP%ISOPEN IS TRUE BEFORE CLOSE' ELSE 'C_EMP%ISOPEN IS FALSE BEFORE CLOSE' END);
    CLOSE C_EMP;
    DBMS_OUTPUT.PUT_LINE(CASE WHEN C_EMP%ISOPEN THEN 'C_EMP%ISOPEN IS TRUE AFTER CLOSE' ELSE 'C_EMP%ISOPEN IS FALSE AFTER CLOSE' END);
END;
/


-- Practical 

-- 1. Fetch all the employees with saalry in odd number and print them in desc order of the salary using cursor.
DECLARE
    CURSOR C_EMP_ODD IS SELECT * FROM AS_EMPLOYEES WHERE MOD(SALARY,2) = 1 ORDER BY SALARY DESC;
    V_DATA C_EMP_ODD%ROWTYPE;
BEGIN
    OPEN C_EMP_ODD;
    LOOP
        FETCH  C_EMP_ODD INTO V_DATA;
        EXIT WHEN C_EMP_ODD%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_DATA.EMP_ID || ' | ' || V_DATA.FIRSTNAME || ' | ' || V_DATA.LASTNAME || ' | ' || V_DATA.DEPT_ID || ' | ' || V_DATA.SALARY);
    END LOOP;
    CLOSE C_EMP_ODD;
END;
/


-- 2. Print the details of all the employees with salry in ascending order and stop printing the data when 2nd odd salaried employee is encountered.
DECLARE
    CURSOR C_EMP_ODD IS SELECT * FROM AS_EMPLOYEES ORDER BY SALARY nulls last;
    V_DATA C_EMP_ODD%ROWTYPE;
    V_ODD_SALARY_FLAG NUMBER := 0;
BEGIN
    OPEN C_EMP_ODD;
    LOOP
        FETCH  C_EMP_ODD INTO V_DATA;
        EXIT WHEN (C_EMP_ODD%NOTFOUND OR V_ODD_SALARY_FLAG = 2);
        IF MOD(V_DATA.SALARY,2) = 1 THEN
            V_ODD_SALARY_FLAG := V_ODD_SALARY_FLAG + 1;
        END IF;
        DBMS_OUTPUT.PUT_LINE(V_DATA.EMP_ID || ' | ' || V_DATA.FIRSTNAME || ' | ' || V_DATA.LASTNAME || ' | ' || V_DATA.DEPT_ID || ' | ' || V_DATA.SALARY);
        
    END LOOP;
    CLOSE C_EMP_ODD;
END;
/
set SERVEROUTPUT on;
select * from as_employees;


-- 3. Loop through all the departments one by one and print name of all employees per department seperated by ">" in single line.
DECLARE
    CURSOR C_DEPT IS SELECT * FROM AS_DEPARTMENTS ORDER BY DEPT_ID;
    V_DEPT_DATA C_DEPT%ROWTYPE;
    V_EMPLOYEES VARCHAR2(1000);
BEGIN
    OPEN C_DEPT;
    LOOP
        FETCH C_DEPT INTO V_DEPT_DATA;
        EXIT WHEN C_DEPT%NOTFOUND;
        SELECT LISTAGG(FIRSTNAME, ' > ') WITHIN GROUP (ORDER BY FIRSTNAME)
        INTO V_EMPLOYEES 
        FROM AS_EMPLOYEES
        WHERE DEPT_ID = V_DEPT_DATA.DEPT_ID;
        DBMS_OUTPUT.PUT_LINE(V_DEPT_DATA.NAME || '  :  ' || V_EMPLOYEES);
    END LOOP;
    CLOSE C_DEPT;
END;
/

-- 4. Loop through all the departments and print the total slary of the employees in each dept  
DECLARE
    CURSOR C_DEPT IS SELECT * FROM AS_DEPARTMENTS ORDER BY DEPT_ID;
    V_DEPT_DATA C_DEPT%ROWTYPE;
    V_SALRY_SUM VARCHAR2(1000);
BEGIN
    OPEN C_DEPT;
    LOOP
        FETCH C_DEPT INTO V_DEPT_DATA;
        EXIT WHEN C_DEPT%NOTFOUND;
        SELECT sum(salary)
        INTO V_SALRY_SUM 
        FROM AS_EMPLOYEES
        WHERE DEPT_ID = V_DEPT_DATA.DEPT_ID;
        DBMS_OUTPUT.PUT_LINE(V_DEPT_DATA.NAME || '  :  ' || V_SALRY_SUM);
    END LOOP;
    CLOSE C_DEPT;
END;
/




-- PARAMETARISED CURSOR

-- Practical
-- 1. Using the parametarised cursor,
--      fetch and print the details of all the employees with slary > 10000 in ascending order
--      fetch and print the details of all the employees with salry > 6000 in ascending order.
select * from as_employees;
declare
    cursor C1 (slry number) is
    select * from as_employees where salary > slry order by salary;
    v_data C1%rowtype;
begin
    open C1(10000);
    loop
        fetch C1 into v_data;
        exit when C1%notfound;
        DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT || ' | ' || v_data.EMP_ID || ' | ' || v_data.FIRSTNAME || ' | ' || v_data.LASTNAME || ' | ' || v_data.DEPT_ID || ' | ' || v_data.SALARY);
    end loop;
    close C1;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    
    open C1(6000);
    loop
        fetch C1 into v_data;
        exit when C1%notfound;
        DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT || ' | ' || v_data.EMP_ID || ' | ' || v_data.FIRSTNAME || ' | ' || v_data.LASTNAME || ' | ' || v_data.DEPT_ID || ' | ' || v_data.SALARY);
    end loop;
    close C1;
end;
/

-- 2. Using the parametarised cursor,
--      fetch and print the details of all employees with HR department
--      fetch and print the details of all emplloyees with Admin department
select * from as_departments;
declare
    cursor C1 (d_name VARCHAR2) is
    select * from as_employees 
    where dept_id = (select dept_id 
        from as_departments 
        where name = d_name);
    v_data C1%rowtype;
begin
    open C1('HR');
    DBMS_OUTPUT.PUT_LINE('-------- HR Department ---------');
    loop
        fetch C1 into v_data;
        exit when C1%notfound;
        DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT || ' | ' || v_data.EMP_ID || ' | ' || v_data.FIRSTNAME || ' | ' || v_data.LASTNAME || ' | ' || v_data.DEPT_ID || ' | ' || v_data.SALARY);
    end loop;
    close C1;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    
    open C1('Admin');
    DBMS_OUTPUT.PUT_LINE('-------- Admin Department ---------');
    loop
        fetch C1 into v_data;
        exit when C1%notfound;
        DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT || ' | ' || v_data.EMP_ID || ' | ' || v_data.FIRSTNAME || ' | ' || v_data.LASTNAME || ' | ' || v_data.DEPT_ID || ' | ' || v_data.SALARY);
    end loop;
    close C1;
end;
/

-- 3. Using the parametarised cursor,
--      find if the given number is indivisible and try with 3-4 numbers.

declare
    cursor C1 (num number) is
    select num as nmbr, level as divisor from dual
    connect by level <= num-1;
    v_data C1%rowtype;
    v_is_divisible boolean := false;
begin
    open C1(701);

    loop
        fetch C1 into v_data;
        exit when (C1%notfound or v_is_divisible);
        continue when v_data.divisor = 1;
        if mod(v_data.nmbr,v_data.divisor) = 0 then
            DBMS_OUTPUT.PUT_LINE('The number ' || v_data.nmbr || ' is divisible by ' || v_data.divisor);
            v_is_divisible := true;
            exit;
        end if;
    end loop;
    if not v_is_divisible then
        DBMS_OUTPUT.PUT_LINE('The number ' || v_data.nmbr || ' is a PRIME NUMBER.. ');
    end if;
    close C1;
end;
/
set SERVEROUTPUT on;

select 7 as nmbr,level as divisor from dual
connect by level <= 7 - 1;





-- CURSOR IN FOR LOOP
set SERVEROUTPUT on;
begin
    for i in (select * from as_departments)
    loop
        dbms_output.put_line('Dept ID : ' || i.dept_id);
        dbms_output.put_line('Dept NAME : ' || i.name);
        dbms_output.put_line('Dept CITY : ' || i.city);
    end loop;
end;
/

-- 1. Using for loop, print the details of employees of HR department.
BEGIN
    FOR emp IN (
        SELECT *
        FROM
            as_employees
        WHERE
            dept_id = (
                SELECT dept_id
                FROM as_departments
                WHERE name = 'HR'
            )
    ) LOOP
        dbms_output.put_line('EMP_ID : '
                             || emp.emp_id
                             || ' |  FIRSTNAME : '
                             || emp.firstname
                             || ' |  LASTNAME : '
                             || emp.lastname
                             || ' |  DEPT_ID : '
                             || emp.dept_id
                             || ' |  SALARY : '
                             || emp.salary);
    END LOOP;
END;
/


-- 2. Using for loop, update the slary of the employee by 10% + (1*count)% --> here "count" is the number of employees with lower slary than the current employee in the department.
declare
    v_emp_no_in_dept number :=0;
    v_prev_count number := 0;
begin 
    for emp in (select * from as_employees order by dept_id,salary) 
    loop   
        if v_prev_count <> emp.dept_id then
            v_emp_no_in_dept := 0;
        end if;
        
        update as_employees 
        set salary = salary + salary * 0.1 + salary * (v_emp_no_in_dept/100) 
        where emp_id = emp.emp_id;
        
        v_emp_no_in_dept := v_emp_no_in_dept + 1;
        v_prev_count := emp.dept_id;
    end loop;
end;
/
rollback;

-- OR
-- doing the same thing using analytical function
begin 
    for i in (select E.*, row_number() over (partition by dept_id order by salary)-1 as RN from as_employees E) 
    loop
        update as_employees 
        set salary = salary + salary * ((10 + i.RN)/100) 
        where emp_id = i.emp_id;
    end loop;
    dbms_output.put_line('Table updated successfully..');
end;
/
select E.*, row_number() over (partition by dept_id order by salary)-1 as RN from as_employees E;



-- 3. Using for loop fetch and print the data of employees with odd salary.
declare
    v_chk as_employees.dept_id%type;
begin
    for i in (select * from as_employees where mod(salary,2)=1) loop 
        dbms_output.put_line(i.emp_id || '  | ' || i.firstname || '   ' || i.dept_id ||'  ===>>   :  ');
    end loop;
    if v_chk <> 1 then
        dbms_output.put_line('Checked...');
    end if;
end;
/




-- Assignment

-- 1. Use the basic cursor to ganerate 1-100 number (hierarchy query) ==> add all num, skip addig 51 to 60
declare
    cursor v_c_num is select level as NUM from dual connect by level <=100;
    v_num number;
    v_sum number := 0;
begin
    open v_c_num;
    loop
        fetch v_c_num into v_num;
        exit when v_c_num%notfound;
        dbms_output.put_line('Current Number is ====>>  '||v_num);
        continue when v_num between 51 and 60;
        v_sum := v_sum + v_num;
    end loop;
    dbms_output.put_line('The Total is  :  ' || v_sum);
    close v_c_num;
end;
/


-- 2, Use for loop to fetch all the employees of dept_id 2 and loop through it. print the name of all the employees whose salary is less than current employee.
declare
    V_EMPLOYEES VARCHAR2(3200);
begin
    for emp in (select * from as_employees where dept_id = 2)
    loop
        dbms_output.put_line('EMP_ID : ' || emp.EMP_ID || ' |  FIRSTNAME : ' || emp.FIRSTNAME || ' |  LASTNAME : ' || emp.LASTNAME || ' |  DEPT_ID : ' || emp.DEPT_ID || ' |  SALARY : ' || emp.SALARY);  
        SELECT LISTAGG(FIRSTNAME, ' , ') WITHIN GROUP (ORDER BY FIRSTNAME)
        INTO V_EMPLOYEES 
        FROM AS_EMPLOYEES
        WHERE SALARY < emp.SALARY;
        dbms_output.put_line('Lower Salary than : ' || emp.firstname || ' are ==>  ' || V_EMPLOYEES);
    end loop;
end;
/

