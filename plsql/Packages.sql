create or replace package hr_pkg as

    -- public constant
    c_max_raise_pct constant number := 20;
    -- public custom exception
    e_invalid_raise exception;
    -- public procedures
    procedure hire_employee(
        p_firstname in varchar2,
        p_lastname  in varchar2,
        p_salary    in number,
        p_dept_id   in number,
        p_job_id    in varchar2
    );

    procedure give_raise(
        p_employee_id in number,
        p_percent     in number
    );

    -- public function (overloaded: same name, different parameters)
    function get_salary(p_employee_id in number) return number;
    function get_salary(p_lastname in varchar2) return number;

    function dept_avg_salary(p_dept_id in number) return number;

end hr_pkg;
/


create or replace package body hr_pkg as

    -- package-level variable: lives for the whole session
    g_hires_this_session number := 0;

    -- PRIVATE function: not in the spec, so only code inside this body can call it
    function is_valid_salary(p_salary in number) return boolean is
    begin
        return p_salary > 0;
    end is_valid_salary;

    procedure hire_employee(
        p_firstname in varchar2,
        p_lastname  in varchar2,
        p_salary    in number,
        p_dept_id   in number,
        p_job_id    in varchar2
    ) is
    begin
        if not is_valid_salary(p_salary) then
            raise_application_error(-20001, 'Salary must be greater than zero');
        end if;

        insert into as_employees (emp_id, firstname, lastname, salary, dept_id,job_id)
        values (EMPLOYEES_SEQ.nextval, p_firstname, p_lastname, p_salary, p_dept_id, p_job_id);

        g_hires_this_session := g_hires_this_session + 1;
        dbms_output.put_line('Hires this session: ' || g_hires_this_session);
    end hire_employee;

    procedure give_raise(
        p_employee_id in number,
        p_percent     in number
    ) is
    begin
        if p_percent > c_max_raise_pct then
            raise e_invalid_raise;
        end if;

        update as_employees
        set salary = salary + (salary * p_percent / 100)
        where emp_id = p_employee_id;
    end give_raise;

    function get_salary(p_employee_id in number) return number is
        v_salary number;
    begin
        select salary into v_salary
        from as_employees
        where emp_id = p_employee_id;
        return v_salary;
    end get_salary;

    -- overloaded version: look up by last name instead
    function get_salary(p_lastname in varchar2) return number is
        v_salary number;
    begin
        select salary into v_salary
        from as_employees
        where lastname = p_lastname;
        return v_salary;
    end get_salary;

    function dept_avg_salary(p_dept_id in number) return number is
        v_avg number;
    begin
        select avg(salary) into v_avg
        from as_employees
        where dept_id = p_dept_id;
        return v_avg;
    end dept_avg_salary;

end hr_pkg;
/


create table emp_salary_inc_audit (
    log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_id number,
    dept_id number,
    old_salary number,
    new_salary number,
    last_updated_at date,
    constraint fk_inc_sal_log_emp_id foreign key (emp_id) references as_employees(emp_id),
    constraint fk_inc_sal_log_dept_id foreign key (dept_id) references as_departments(dept_id)
);

create or replace trigger trg_emp_saly_incrmnt_log before
update of salary on as_employees
for each row
begin
    insert into emp_salary_inc_audit values(:new.emp_id,:new.dept_id,:old.salary,:new.salary,sysdate);
end;
/


begin
--    hr_pkg.hire_employee('Adil', 'Khan', 60000, 3, 'Developer');
    hr_pkg.give_raise(1011, 10);
end;
/

begin
    hr_pkg.hire_employee('Asif', 'Ali', 62000, 1, 'Manager');
    hr_pkg.give_raise(101, 10);
    dbms_output.put_line(hr_pkg.get_salary(1011));        -- calls the employee_id version
    dbms_output.put_line(hr_pkg.get_salary('Ahmad'));    -- calls the lastname version
    dbms_output.put_line(hr_pkg.dept_avg_salary(1));
end;
/

-- calling function directly from SQL
select hr_pkg.dept_avg_salary(1) from dual;

select * from as_employees where emp_id = 1011;
select * from as_departments;