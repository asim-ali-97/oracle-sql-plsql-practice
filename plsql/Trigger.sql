-- TRIGGER --> ROW-LEVEL, STATEMENT-LEVEL

--✅ When should you use a trigger
--		Use a trigger when the database itself needs to guarantee something automatically whenever a particular database event occurs.

--Good candidates:

--✅ Auditing
--Who changed what and when?
--✅ Automatically maintaining metadata
--created_at
--updated_at
--created_by
--✅ Database-wide enforcement

--For example:

--An employee cannot belong to an inactive department.

--Especially when multiple applications access the same database.

--✅ History tables
--Order status history
--Employee salary history
--Customer address history

--❌ Don't use a trigger when a constraint can do the job


SELECT * FROM AS_DEPARTMENTS ORDER BY DEPT_ID;
SELECT * FROM AS_EMPLOYEES;
ALTER TABLE AS_DEPARTMENTS ADD IS_ACTIVE NUMBER(1) DEFAULT 1 NOT NULL;
UPDATE AS_DEPARTMENTS SET IS_ACTIVE = 0 WHERE DEPT_ID = 4;
COMMIT;
SELECT * FROM AS_EMPLOYEES ORDER BY DEPT_ID DESC NULLS LAST;


--  ROW-LEVEL
CREATE OR REPLACE TRIGGER trg_employee_dept_id_active BEFORE
    INSERT OR UPDATE ON as_employees
    FOR EACH ROW
    WHEN ( new.dept_id IS NOT NULL )
DECLARE
    v_cnt NUMBER := 0;
BEGIN
    SELECT
        COUNT(1)
    INTO v_cnt
    FROM
        as_departments
    WHERE
            dept_id = new.dept_id
        AND is_active = 1;

    IF v_cnt = 0 THEN
        raise_application_error(-20011,
                                'YOU CANNOT ADD EMPLOYEE IN DEPARTMENT: ' || :new.dept_id);
    END IF;

END;
/


-- STATEMENT-LEVEL
CREATE OR REPLACE TRIGGER trg_emp_stmt_delete_rstrction BEFORE
    DELETE ON as_employees
DECLARE
    v_cnt NUMBER := 0;
BEGIN
    SELECT
        COUNT(1)
    INTO v_cnt
    FROM
        as_departments
    WHERE
        is_active = 0;

    IF v_cnt > 0 THEN
        raise_application_error(-20012, 'YOU CANNOT DELETE EMPLOYEE WHEN ONE OF THE DEPARTMENT IS INACTIVE');
    END IF;
END;
/



create table employees (
id number generated ALWAYS as IDENTITY,
name varchar2(20),
dept_id varchar2(20),
constraint pk_employees primary key(id),
constraint fk_employees_dept FOREIGN key (dept_id) REFERENCES departments(dept_id)
);

create table departments (
dept_id varchar2(20),
name varchar2(20),
constraint pk_departments primary key (dept_id)
);

select * from employees;
select * from departments;

alter table departments add is_active number(1) default 1 not null;
alter table employees add salary number check(salary >= 0);
insert into departments values('DPT102','HR',0);


-- Trigger to avoid adding employees to an inactive department
create or replace trigger TRG_EMPLOYEES_INSERT before
    insert on employees
    for each row
    when (new.dept_id is not null)
declare
    v_cnt number := 0;
begin
    select count(*) into v_cnt from departments where dept_id = :new.dept_id and is_actIve = 1;
    if v_cnt = 0 then
        raise_application_error(-20001,'YOU CANNOT ADD EMPLOYEE TO AN INACTIVE DEPARTMENT ');
    end if;
end;
/

insert into employees(name,dept_id) values('Asif Raza','DPT101');
select * from employees;


-- Creating trigger on employees and quering the same table in the trigger to raise "table is mutating" error
CREATE OR REPLACE TRIGGER trg_employees_mutating
AFTER INSERT or update ON employees
FOR EACH ROW
declare
    v_cnt number;
BEGIN

    SELECT COUNT(*)
    INTO v_cnt
    FROM employees;  --  triggering table
    
    dbms_output.put_line('count is : ' || v_cnt);

END;
/

-- Compound Trigger --> using compound trigger to avoid mutating error
create or replace trigger trg_employees_compound
FOR insert or update on employees
COMPOUND TRIGGER

    type t_employee_ids is table of employees.id%type;
    l_emp_ids t_employee_ids := t_employee_ids();
    
    after each row is
    begin
        l_emp_ids.extend;
        l_emp_ids(l_emp_ids.count) := :new.id;
    end after each row;
    
    after statement is
        v_salary number;
    begin
        for i in 1..l_emp_ids.count loop
            select salary
            into v_salary
            from employees
            where id = l_emp_ids(i);
            
            dbms_output.put_line('Salary of employee with id: ' || l_emp_ids(i) || ' is --> ' || v_salary);
        end loop;
    end after statement;
end;
/

update employees set salary = 1000 + employees.id;
update employees set salary = salary + id*10;

select * from employees;
alter table employees add last_updated number check(salary >= 0);



--✅ Auditing
create table EMPLOYEE_AUDIT (
    emp_id number,
    old_salary number,
    new_salary number,
    changed_by varchar2(50),
    changed_at timestamp,
    constraint fk_employee_audit_employees foreign key (emp_id) references employees(id)
);

alter table EMPLOYEE_AUDIT drop constraint pk_employee_audit;

select * from user_constraints where table_name = 'EMPLOYEE_AUDIT' and constraint_type = 'P';
alter table EMPLOYEE_AUDIT rename constraint SYS_C008232 to pk_employee_audit;
select * from EMPLOYEE_AUDIT;

-- TRIGGER TO KEEP RECORD WHENEVER SOMEONE CHANGES SALARY OF EMPLOYEE
CREATE OR REPLACE TRIGGER TRG_EMPLOYEE_SALARY_AUDIT
AFTER UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
BEGIN
    INSERT INTO EMPLOYEE_AUDIT 
        (EMP_ID, OLD_SALARY, NEW_SALARY, CHANGED_BY, CHANGED_AT)
    VALUES 
        (:OLD.ID,
         :OLD.SALARY,
         :NEW.SALARY,
         USER,
         SYSDATE);
    commit;
    dbms_output.put_line('Audit log created successfully..');

END;
/
select * from employees;
update employees set salary = salary + id * 10 where id = 16;

select * from employee_audit;