-- LOOP, FOR LOOP, WHILE LOOP, CONTINUE


-- LOOP Practical
-- Using the basic loop, create the multiplication table of 3.
declare
    v_num number := 1;
begin
    loop
        dbms_output.put_line('3 x ' || v_num || ' = ' || v_num*3);
        v_num := v_num + 1;
        if v_num > 10 then
            exit;
        end if;
    end loop;
end;
/


-- Using basic loop print the current second of the time 48 times
set serveroutput on;
declare
    v_num number := 1;
    v_sec number;
begin
    loop
        select to_char(sysdate, 'ss') into v_sec from dual;
        dbms_output.put_line(v_num || ' Current Second is : ' || v_sec);
        --dbms_output.put_line(v_num || ' Current Second is : ' || tochar(sysdate, 'ss')); need to look at this tomorrow
        v_num := v_num + 1;
        exit when v_num > 48;
    end loop;
end;
/



-- FOR LOOP

-- create table of 3 using for loop
begin
    for i in 1..10
    loop
        dbms_output.put_line('3 x ' || i || ' = ' || 3*i);
    end loop;
end;
/

--Print all prime numbers between 1 and 100 using for loop
declare
    v_prime boolean := true;
begin
    for i in 1..100 
    loop
        v_prime := true;
        if i > 2 then
            for j in 2..i-1
            loop
                if mod(i,j) = 0 then
                    v_prime := false;
                    goto next_number;
                end if;
            end loop;
        end if;
        if v_prime then
            dbms_output.put_line(i || ' is a Prime Number');
        end if;
        <<next_number>>
        null;
    end loop;
end;
/



-- WHILE LOOP

-- print table of 3 using while loop
set serveroutput on;
declare
    v_num number := 1;
begin
    while v_num <= 10
    loop
        dbms_output.put_line('3 x ' || v_num || ' = ' || v_num*3);
        v_num := v_num + 1;
    end loop;
end;
/


-- using while loop, create the series of X^2 + 5 till 300. X starts from 1
declare
    x number :=1;
    v_limit number := 0;
begin
    while v_limit <= 300 loop
        v_limit := power(x,2)+5;
        exit when v_limit > 300;
            dbms_output.put_line('X is ' || x || ' and Series is = ' || v_limit);
        x:=x+1;
    end loop;
end;
/

-- Using while loop, insert 10 records into one temporary table (create table with one number column), you can add any number but all different
create table temp_tbl(
    coll number
);

declare
    I number :=1;
begin
    while I <= 10
    loop
        insert into temp_tbl values(I*7+23);
        I:=I+1;
    end loop;
end;
/
rollback;
drop table temp_tbl;



-- CONTINUE

-- insert all characters between A-O (case insensitive) into table (create one table of one cloumn). given string "LEARNVERN"
   -- one character should be inserted once only, use continue
set serveroutput on;
create table temp_ch(
    characters VARCHAR2(1)
);

select * from temp_ch;

declare
    v_string varchar2(10) := 'LEARNVERN';
    j number := 1;
begin
    for j in 1..length(v_string) 
    loop
        continue when not(substr(v_string,j,1) between 'A' and 'O' or substr(v_string,j,1) between 'a' and 'o');
        dbms_output.put_line('character is  ;  ' || substr(v_string,j,1));
        for i in 1..j-1 loop
            dbms_output.put_line(substr(v_string,i,1) || '  ;  ' || substr(v_string,j,1));
            if substr(v_string,i,1) = substr(v_string,j,1) then 
                goto skipp; 
            end if;         
        end loop;
        insert into temp_ch values(substr(v_string,j,1));
        <<skipp>>
        null;
    end loop;
end;
/


-- Look through all the odd numbers between 100-200 and exit if that number is indivisible (use CONTINUE and EXIT)
declare
    v_is_divisible boolean := false;
begin 
    for i in 160..200
    loop
        v_is_divisible := false;
        continue when mod(i,2) = 0;
        for j in 2..i-1 
        loop
            if mod(i,j) = 0 then
                v_is_divisible := true;
                exit;
            end if;
        end loop;
        if v_is_divisible = false then
            dbms_output.put_line(i || ' is indivisible' );
            exit;
        end if;
    end loop;
end;
/


-- Seperate each digit of the 987654321987123 and print only if it is odd. 
declare
    v_num number := 987654321987123;
    i number :=1;
begin
    while i <= length(v_num)
    loop
        if mod(substr(v_num,i,1),2) = 1 then
            dbms_output.put_line(substr(v_num,i,1));
        end if;
        i:=i+1;
    end loop;
end;
/
-- OR
declare
    v_num number := 987654321987123;
    i number;
begin
    while v_num > 0
    loop
        i := v_num - trunc(v_num/10)*10;
        if mod(v_num,2) = 1 then
            dbms_output.put_line(i);
        end if;
        v_num := trunc(v_num/10);
    end loop;
end;
/



-- Assignment on Iteration
-- create a pl/sql block to use while loop to execute for 2 seconds, add 2 to it in each iteration, initialize variable with 0 and print value at end.
set serveroutput on;
declare
    v_num number := 0;
    v_future TIMESTAMP;
begin
    v_future := systimestamp + interval '2' second;
    while systimestamp <= v_future loop
        v_num:= v_num+1;
    end loop;
    DBMS_OUTPUT.PUT_LINE('The number after 2 Seconds is ; ' || v_num);
    
end;
/

--Create a pl/sql block, declare a variable and initialize it with 1, start a loop and multiply odd numbers with the variable until its value exceeds 1000 then exit.
set serveroutput on;
declare
    v_num number := 1;
    v_odd number := 1;
begin
    loop
        v_num:=v_odd*v_num;
        exit when v_num >1000;
        DBMS_OUTPUT.PUT_LINE(v_num || ' : Odd number is : ' || v_odd);
        v_odd := v_odd+2;
    end loop;
end;
/
select * from dual;
