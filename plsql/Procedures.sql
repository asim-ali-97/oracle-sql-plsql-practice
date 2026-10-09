-- PROCEDURES 

CREATE OR REPLACE PROCEDURE my_first_proc
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLOW WORLD');
END my_first_proc;
/

BEGIN
    my_first_proc;
END;
/

CREATE OR REPLACE PROCEDURE my_first_proc (P_IN_USERNAME VARCHAR2)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLOW USER:  ' || P_IN_USERNAME);
END my_first_proc;
/

DECLARE
    V_STRING VARCHAR2(2000) := 'Out variable';
    v_third_param varchar2(100) := 'MUSTAFA';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_third_param);
    my_first_proc('ASIM', V_STRING, v_third_param);
    DBMS_OUTPUT.PUT_LINE(V_STRING);
    DBMS_OUTPUT.PUT_LINE(v_third_param);
    my_first_proc(
    P_IN_USERNAME => NULL,
    P_OUT_STRING => V_STRING,
    p_in_out_string => v_third_param
  );
  DBMS_OUTPUT.PUT_LINE(v_third_param);

END;
/

select * from user_procedures where object_name = 'MY_FIRST_PROC';
select * from user_procedures where object_type = 'PROCEDURE';
select * from user_source where NAME = 'MY_FIRST_PROC' order by line;
select * from user_objects where object_type = 'PROCEDURE';
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME = 'MY_FIRST_PROC';


CREATE OR REPLACE PROCEDURE MY_SCND_PROC
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLOW WORLD');
END;
/

drop PROCEDURE MY_SCND_PROC;
drop PROCEDURE MY_FIRST_PROC;
select * from user_source where name = 'MY_FIRST_PROC';





--           ASSIGNMENT 

-- Create one table to store logs(log_id, log_ts, action_taken)
-- 1. Create the procedure to update the slary of the employee by given percentage. (emp_id, dept_id, increment_percentage as input)
--    log the data into log table if provided data is incorrect.

CREATE TABLE AS_ASSIGNMENT_LOGS (
    LOG_ID NUMBER,
    LOG_TS TIMESTAMP,
    LOG_DESCRIPTON VARCHAR2(4000)
);

CREATE SEQUENCE AS_ASSIGNMENT_LOGS_SEQ;


create or replace PROCEDURE P_INC_SALARY (
    P_IN_EMP_ID IN NUMBER,
    P_IN_DEPT_ID IN AS_DEPARTMENTS.DEPT_ID%TYPE,
    P_IN_INCR_PERCT IN NUMBER,
    P_OUT_MESSAGE OUT VARCHAR2
)
AS
    V_DEPT_ID AS_DEPARTMENTS.DEPT_ID%TYPE;
BEGIN
    P_OUT_MESSAGE := 'SUCCESSFUL';
    BEGIN
        SELECT 
            DEPT_ID INTO V_DEPT_ID 
        FROM 
            AS_EMPLOYEES 
        WHERE 
            EMP_ID = P_IN_EMP_ID;  
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO AS_ASSIGNMENT_LOGS
            VALUES (
                AS_ASSIGNMENT_LOGS_SEQ.NEXTVAL,
                SYSTIMESTAMP,
                'GIVEN EMPLOYEE ID: ' || P_IN_EMP_ID || ' IS NOT VALID'
            );
            P_OUT_MESSAGE := 'FAILED';
            COMMIT;
            RETURN;
    END;

    IF V_DEPT_ID <> P_IN_DEPT_ID THEN
        INSERT INTO AS_ASSIGNMENT_LOGS
            VALUES (
                AS_ASSIGNMENT_LOGS_SEQ.NEXTVAL,
                SYSTIMESTAMP,
                'GIVEN EMPLOYEE ID: ' || P_IN_DEPT_ID || ' IS NOT MAPPED AGAINST EMPLOYEE ID: ' || P_IN_EMP_ID
            );
            P_OUT_MESSAGE := 'FAILED';
            COMMIT;
            RETURN;
    END IF;

    UPDATE AS_EMPLOYEES 
    SET 
        SALARY = trunc(SALARY + (SALARY*P_IN_INCR_PERCT/100))
    WHERE 
        EMP_ID = P_IN_EMP_ID;
    COMMIT;
    
END P_INC_SALARY;

SET SERVEROUT ON;
DECLARE
    V_OUT_MSG VARCHAR2(100);
BEGIN
    P_INC_SALARY(1010,2,10,V_OUT_MSG); --5900
    DBMS_OUTPUT.PUT_LINE(V_OUT_MSG);
END;
/

SELECT * FROM AS_EMPLOYEES; 
SELECT * FROM AS_ASSIGNMENT_LOGS;


-- 2. Create the procedure that can be used for login flow. It should accept username(firstname), password (lastname@emp_id)
--``    `validate the data, return success/failed as an output and make an entry in logs table if failed (AS_ASSIGNMENT_LOGS)
create or replace PROCEDURE as_login_validation (
    p_in_username IN as_employees.firstname%TYPE,
    p_in_pswd     IN VARCHAR2,
    p_out_msg     OUT VARCHAR2
) AS

    v_lname  as_employees.lastname%TYPE;
    v_fname  as_employees.firstname%TYPE;
    v_emp_id VARCHAR2(100);
    v_pswd   VARCHAR2(100);
BEGIN
    p_out_msg := 'SUCCESSFUL';
    v_emp_id := substr(p_in_pswd,
                       instr(p_in_pswd, '@', 1) + 1);

    BEGIN
        SELECT
            lastname,
            firstname
        INTO
            v_lname,
            v_fname
        FROM
            as_employees
        WHERE
            emp_id = v_emp_id;

    EXCEPTION
        WHEN OTHERS THEN
            p_out_msg := 'FAILED: ====>  INVALID PASSWORD';
            ROLLBACK;
            INSERT INTO as_assignment_logs VALUES ( as_assignment_logs_seq.NEXTVAL,
                                                    systimestamp,
                                                    'AS_LOGIN_VALIDATION ==> GIVEN PASSWORD IS NOT VALID' );
            COMMIT;
            RETURN;
    END;

    v_pswd := concat(v_lname,
                     concat('@', v_emp_id));
    IF v_pswd <> p_in_pswd THEN
        p_out_msg := 'FAILED: ====>  INVALID PASSWORD';
        ROLLBACK;
        INSERT INTO as_assignment_logs VALUES ( as_assignment_logs_seq.NEXTVAL,
                                                systimestamp,
                                                'AS_LOGIN_VALIDATION ==> GIVEN PASSWORD IS NOT VALID' );
        COMMIT;
        RETURN;
    ELSIF v_fname <> p_in_username THEN
        p_out_msg := 'FAILED: ==>  INVALID USERNAME';
        ROLLBACK;
        INSERT INTO as_assignment_logs VALUES ( as_assignment_logs_seq.NEXTVAL,
                                                systimestamp,
                                                'AS_LOGIN_VALIDATION ==> GIVEN USERNAME "' || p_in_username ||'" IS NOT VALID' );
        COMMIT;
        RETURN;
    END IF;

    dbms_output.put_line('LOGIN SUCCESSFUL..');
END as_login_validation;


DECLARE
    V_MSG VARCHAR2(100);
BEGIN
    AS_LOGIN_VALIDATION('Alamgir','Ahmad@1003',V_MSG);
    DBMS_OUTPUT.PUT_LINE(V_MSG);
END;
/

SELECT * FROM AS_EMPLOYEES;
SELECT * FROM AS_ASSIGNMENT_LOGS;





-- ASSIGNMENT PART-2

--  1. Create the procedure to update the department of the lowest salaried employee of the department of the passed(input) employee
--      to the next highest average salaried department. Insert the logs into log table (Assignment_logs).
create or replace PROCEDURE p_update_dep_low_sal_emp (
    p_in_emp_id       IN as_employees.emp_id%TYPE,
    p_out_status_code OUT NUMBER
) AS
    v_dept_id         as_departments.dept_id%TYPE;
    v_emp_id          as_employees.emp_id%TYPE;
    v_dept_avg_salary NUMBER;
BEGIN
    p_out_status_code := 200;
    BEGIN
        SELECT
            dept_id
        INTO v_dept_id
        FROM
            as_employees
        WHERE
            emp_id = p_in_emp_id;

    EXCEPTION
        WHEN no_data_found THEN
            p_out_status_code := -1;
            dbms_output.put_line('P_UPDATE_DEP_LOW_SAL_EMP --> EMP_ID: '
                                 || p_in_emp_id
                                 || ' IS INVALID');
            ROLLBACK;
            INSERT INTO as_assignment_logs VALUES ( assignment_logs_seq.NEXTVAL,
                                                    systimestamp,
                                                    'P_UPDATE_DEP_LOW_SAL_EMP --> EMP_ID: '
                                                    || p_in_emp_id
                                                    || ' IS INVALID' );

            COMMIT;
            RETURN;
    END;

    IF v_dept_id IS NULL THEN
        p_out_status_code := -1;
        dbms_output.put_line('P_UPDATE_DEP_LOW_SAL_EMP --> DEPARTMENT OF EMP_ID: '
                             || p_in_emp_id
                             || ' IS NULL.');
        ROLLBACK;
        INSERT INTO as_assignment_logs VALUES ( assignment_logs_seq.NEXTVAL,
                                                systimestamp,
                                                'P_UPDATE_DEP_LOW_SAL_EMP --> DEPARTMENT OF EMP_ID: '
                                                || p_in_emp_id
                                                || ' IS NULL.' );

        COMMIT;
        RETURN;
    END IF;

    SELECT
        emp_id
    INTO v_emp_id
    FROM
        as_employees
    WHERE
        dept_id = v_dept_id
    ORDER BY
        salary
    FETCH first ROW ONLY;

    SELECT
        AVG(salary)
    INTO v_dept_avg_salary
    FROM
        as_employees
    WHERE
        dept_id = v_dept_id;

    BEGIN
        SELECT
            dept_id
        INTO v_dept_id
        FROM
            as_employees
        WHERE
            dept_id IS NOT NULL
        GROUP BY
            dept_id
        HAVING
            AVG(salary) > v_dept_avg_salary
        ORDER BY
            AVG(salary)
        FETCH first ROW ONLY;

    EXCEPTION
        WHEN no_data_found THEN
            p_out_status_code := -1;
            dbms_output.put_line('P_UPDATE_DEP_LOW_SAL_EMP --> DEPARTMENT OF EMP_ID: '
                                 || p_in_emp_id
                                 || ' IS ALREADY HIGHEST SALARIED DEPT.');
            ROLLBACK;
            INSERT INTO as_assignment_logs VALUES ( assignment_logs_seq.NEXTVAL,
                                                    systimestamp,
                                                    'P_UPDATE_DEP_LOW_SAL_EMP --> DEPARTMENT OF EMP_ID: '
                                                    || p_in_emp_id
                                                    || ' IS ALREADY HIGHEST SALARIED DEPT.' );

            COMMIT;
            RETURN;
    END;

    UPDATE as_employees
    SET
        dept_id = v_dept_id
    WHERE
        emp_id = v_emp_id;

END p_update_dep_low_sal_emp;


declare
    v_status_code number;
begin
    p_update_dep_low_sal_emp(1009,v_status_code);--1015 --2
    dbms_output.put_line('Status code is: ' || v_status_code);
end;
/
rollback;
set serverout on;
SELECT * FROM AS_EMPLOYEES order by dept_id,salary;
SELECT * FROM AS_ASSIGNMENT_LOGS;

select dept_id,avg(salary) from as_employees where dept_id is not null group by dept_id order by avg(salary);