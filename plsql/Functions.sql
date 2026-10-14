-- FUNCTION

-- NOTE --> DML operation are not allowed inside select query so we cannot call a function in select query that performs a DML operation.
SET SERVEROUT ON;
CREATE OR REPLACE FUNCTION AS_FN_MY_FIRST_FUNC (P_IN_NUM IN NUMBER) RETURN NUMBER
AS
BEGIN
    RETURN (P_IN_NUM * P_IN_NUM) + 10;
END;
/

DECLARE
    V_RETURN_VAL NUMBER;
    V_OUT_VAL NUMBER;
BEGIN
    V_RETURN_VAL := AS_FN_MY_FIRST_FUNC(5,V_OUT_VAL);
    DBMS_OUTPUT.PUT_LINE(V_RETURN_VAL);
    DBMS_OUTPUT.PUT_LINE(V_OUT_VAL);
END;
/

SELECT AS_FN_MY_FIRST_FUNC(5) FROM DUAL;
SELECT * FROM AS_DEPARTMENTS;

SELECT * FROM USER_PROCEDURES WHERE OBJECT_TYPE = 'FUNCTION';
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION';
SELECT * FROM USER_SOURCE WHERE NAME = 'AS_FN_MY_FIRST_FUNC';



-- ASSIGNMENT PART-1

-- 1. Create the Function to return the average salary of the passed department and use it in the query.
create or replace FUNCTION AS_FN_AVG_SALARY (P_IN_DEPT_ID IN AS_DEPARTMENTS.DEPT_ID%TYPE, P_IN_EMP_ID IN AS_EMPLOYEES.EMP_ID%TYPE) RETURN NUMBER
AS
    V_AVG_SALARY NUMBER := 0;
    V_COUNT NUMBER := 0;
    V_EMP_DEPT_ID AS_EMPLOYEES.dept_id%type;
BEGIN
    IF P_IN_DEPT_ID IS NOT NULL THEN
        SELECT COUNT(1) INTO V_COUNT FROM AS_EMPLOYEES WHERE DEPT_ID = P_IN_DEPT_ID;
        IF V_COUNT = 0 THEN
            RETURN -1;
        ELSE
            SELECT AVG(SALARY) INTO V_AVG_SALARY FROM AS_EMPLOYEES WHERE DEPT_ID = P_IN_DEPT_ID;
            RETURN V_AVG_SALARY;
        END IF;
    ELSIF P_IN_EMP_ID IS NOT NULL THEN
        SELECT DEPT_ID INTO V_EMP_DEPT_ID FROM AS_EMPLOYEES WHERE EMP_ID = P_IN_EMP_ID;
        SELECT COUNT(1) INTO V_COUNT FROM AS_EMPLOYEES WHERE DEPT_ID = V_EMP_DEPT_ID;
        IF V_COUNT = 0 THEN
            RETURN -1;
        ELSE
            SELECT AVG(SALARY) INTO V_AVG_SALARY FROM AS_EMPLOYEES WHERE DEPT_ID = V_EMP_DEPT_ID;
            RETURN V_AVG_SALARY;
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('ERRR : =====>>  INVALID EMP_ID OR DEPT_ID');
        RETURN -111;
    END IF;
    
END AS_FN_AVG_SALARY;
/

SELECT AS_FN_AVG_SALARY(NULL,NULL) FROM DUAL;

DECLARE 
    V_OUT NUMBER;
BEGIN
    V_OUT := AS_FN_AVG_SALARY(22,NULL);
    DBMS_OUTPUT.PUT_LINE(V_OUT);
END;
/

SELECT D.*, AS_FN_AVG_SALARY(D.DEPT_ID)AS AVG_SALARY FROM AS_DEPARTMENTS D;

SELECT * FROM AS_EMPLOYEES;
SELECT * FROM AS_EMPLOYEES WHERE AS_FN_AVG_SALARY(DEPT_ID) < 20000;
SELECT * FROM AS_EMPLOYEES WHERE AS_FN_AVG_SALARY(DEPT_ID) < 20000 AND AS_FN_AVG_SALARY(DEPT_ID) <> -1;



-- Assignment part-2
-- 1. Create a function to calculate and return the tax need to be paid by an employee
--    Tax calculation
--    Salary > 1000 10%
--    Salary > 5000 (on first 1000 --> 10%) + 20% on the remaining amount
--    Salary > 10000 (on first 1000 --> 10%) + (on next 4000 --> 20%) + 30% on the remaining amount

create or replace FUNCTION as_fn_calc_tax (
    p_in_emp_id IN as_employees.emp_id%TYPE
) RETURN NUMBER AS
    v_emp_salary as_employees.salary%TYPE;
    v_sql_error  VARCHAR2(1000);
BEGIN
    SELECT
        salary
    INTO v_emp_salary
    FROM
        as_employees
    WHERE
        emp_id = p_in_emp_id;

    IF v_emp_salary IS NULL THEN
        ROLLBACK;
        INSERT INTO as_assignment_logs VALUES ( as_assignment_logs_seq.NEXTVAL,
                                                systimestamp,
                                                'AS_FN_CALC_TAX  ===>  SALARY FOR GIVEN EMP_ID: '
                                                || p_in_emp_id
                                                || ' IS NULL' );

        RETURN -1;
    END IF;

    IF v_emp_salary < 1000 THEN
        RETURN 0;
    ELSIF
        v_emp_salary >= 1000
        AND v_emp_salary < 5000
    THEN
        RETURN v_emp_salary * 0.1;
    ELSIF
        v_emp_salary >= 5000
        AND v_emp_salary < 10000
    THEN
        RETURN 100 + ( ( v_emp_salary - 1000 ) * 0.2 );
    ELSE
        RETURN 900 + ( ( v_emp_salary - 5000 ) * 0.3 );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        ROLLBACK;
        v_sql_error := sqlerrm;
        INSERT INTO as_assignment_logs VALUES ( as_assignment_logs_seq.NEXTVAL,
                                                systimestamp,
                                                'AS_FN_CALC_TAX  ===>  EMP_ID: '
                                                || p_in_emp_id
                                                || ' NOT FOUND. '
                                                || ' ERROR MSG: ==>>> '
                                                || v_sql_error );

        RETURN -1;
END as_fn_calc_tax;
/


SET SERVEROUT ON;
DECLARE
    V_TAX NUMBER;
    V_EMD_ID AS_EMPLOYEES.EMP_ID%TYPE := 1101;
BEGIN
    V_TAX := AS_FN_CALC_TAX(V_EMD_ID);
    DBMS_OUTPUT.PUT_LINE('TAX FOR EMP_ID: ' || V_EMD_ID || ' IS = ' || V_TAX);
END;
/

SELECT * FROM AS_EMPLOYEES;
SELECT * FROM AS_ASSIGNMENT_LOGS;
