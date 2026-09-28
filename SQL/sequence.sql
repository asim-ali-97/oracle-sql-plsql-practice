-- Sequence and default
create sequence car_id_s
    minvalue 101
    maxvalue 199
    start with 101
    increment by 1
    nocache;

create table car_types
    (car_id number default car_id_s.nextval,
    car_name varchar2(100) default 'User Name',
    creation_date date default sysdate
    );
    
alter table car_types add registered varchar2(3) default 'Yes';
alter table car_types modify car_name varchar2(100) default 'Car Name';
insert into car_types (registered) values('NO');
insert into car_types (is_registered) values('NO');
alter table car_types rename column registered to is_registered;
select * from car_types;

delete from car_types where car_id between 150 and 200;
commit;

alter sequence car_id_s increment by 1; --we can alter all the sequence parameters except START WITH using ALTER SEQUENCE command
select car_id_s.nextval from dual;
alter sequence car_id_s restart start with 145;
alter table car_types rename column cars_name to car_name;
alter table car_types modify creation_date timestamp;
commit;

select * from car_types;
select car_id_s.currval from dual;
select car_id_s.nextval from dual;

drop sequence car_id_s;
drop table car_types;

-- Practical of Sequence
-- create the sequence to populate sales_person_id into sales_persons table.
select * from as_sales_persons;
create sequence sales_person_seq
    minvalue 1
    maxvalue 999999999
    start with 8
    increment by 1
    nocycle; -- by default it is nocycle if we dont write it
    --nocache -- also by default the cache is 20

select sales_person_seq.nextval from dual;
drop sequence sales_person_seq;

-- Create sequence jumping_sequence - increment by 1000 - start with 15 -- execute next value for 5 times.
-- Update the jumping_sequence to set increment by 1 and set its next value to 250

create sequence jumping_sequence
    minvalue 15
    maxvalue 999999999
    start with 15
    increment by 1000;
    
select jumping_sequence.currval from dual;
select jumping_sequence.nextval from dual;
alter sequence jumping_sequence increment by 1000;
alter sequence jumping_sequence restart start with 15;
alter sequence jumping_sequence increment by 1;

alter sequence jumping_sequence RESTART start with 250;
select jumping_sequence.nextval from dual;

select 250+100 from dual;

alter sequence jumping_sequence
increment by 100;
select jumping_sequence.nextval from dual; -- now the next val is at 350 lets reset it to 300;

alter sequence jumping_sequence
increment by -50;

alter sequence jumping_sequence -- setting the increment again to 1
increment by 1;

select jumping_sequence.nextval from dual; -- 300

drop sequence jumping_sequence;
