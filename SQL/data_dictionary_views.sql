-- DATA DICTIONARY VIEWS

-- also known as Static Data Dictionary Views because data in these table only changes when table structure changes
-- USER_, ALL_, DBA_

select * from all_all_tables; -- details of all object tables and relational tables
select * from all_all_tables where owner = 'MUSTAN_';
select * from all_tables where owner = 'MUSTAN_'; -- details of all relational tables
SELECT  * from all_objects where owner = 'MUSTAN_' and object_type = 'TABLE'; -- details of all objects

select * from all_tab_cols where owner = 'MUSTAN_'; -- details of all the columns of all the tables including system generated hidden tables
select * from all_tab_cols where owner = 'MUSTAN_' and last_analyzed > to_date(date '2026-05-01') order by last_analyzed asc;

select * from all_tab_columns where owner = 'MUSTAN_'; -- details of columns of the tables
select * from all_tab_comments where owner = 'MUSTAN_'; -- details of comments on the tables

select * from all_tab_privs where table_schema = 'MUSTAN_';
select * from all_tab_privs where 'MUSTAN_' in (grantor, grantee, table_schema);
grant select on as_employees to bi;

select * from all_tab_privs_made; -- the priviliges that the user has made or granted
select * from all_tab_privs_made where grantor = 'MUSTAN_';

select * from all_tab_privs_recd; -- all the grants that the user has recieved
select * from user_tab_privs_recd; -- privs received by user
select * from user_tab_privs_made; -- privs made by user

select * from all_users; -- details of all users visible to the current user.
select * from user_users; -- MUSTAN_

select * from all_views; -- details of all the views accessible to the current user.
select * from user_views;

select * from all_tab_comments;
select * from user_tab_comments;
select * from user_col_comments;

select * from all_constraints;
select * from user_constraints;
select * from user_constraints where constraint_type = 'C';
select * from user_cons_columns;

select * from user_constraints c join user_cons_columns cc on c.constraint_name = cc.constraint_name;

select * from user_indexes;
select * from user_ind_columns;

select * from all_mviews;
select * from user_mviews;

select * from all_mview_logs;
select * from user_mview_logs;

select * from all_synonyms;
select * from user_synonyms;

select * from all_sequences;
select * from user_sequences;
select emp1_seq.nextval from dual;

select * from dictionary;

select * from all_tables;
select * from user_tables;
select * from dba_all_tables;


-- PRACTICAL on Data Dictionary Views

-- all the objects of the current user
select * from all_objects where owner = 'MUSTAN_';
select * from user_objects order by object_type;

-- all table owned by current user
select * from all_tables where owner = 'MUSTAN_';
select * from user_tables;

-- all columns with details of the columns of sales table
select * from all_tab_columns where owner = 'MUSTAN_';
select * from user_tab_columns where table_name = 'AS_SALES';

-- all the constraiint of sales table 
select * from user_constraints where table_name = 'AS_SALES';

-- details of any of FK of the sales table
select * from user_cons_columns where constraint_name = 'FK_SALES_SALES_PERSONS';
select * from user_cons_columns where constraint_name = 'PK_AS_SALES_PERSONS';

-- all synonyms owned by current user
select * from user_synonyms;

-- all the synonyms made on learnvern user's nay objects in learnvern_1 user
select * from all_users;
select * from user_synonyms where TABLE_owner = 'MUSTAN_';

-- all views and mviews owned by current user
select * from user_views;
select * from user_mviews;

-- all the views of learnvern which are accessible by learnver_1
-- we should be in learnver_1 user to perform this
-- learnvern_1
select * from user_views where owner = 'LEARNVERN';

-- all the sequences owned by current user
select * from user_sequences;

-- all the priviledges given MUSTAN_ user to BI
select * from user_tab_privs_made where grantee = 'BI' and grantor = 'MUSTAN_';

