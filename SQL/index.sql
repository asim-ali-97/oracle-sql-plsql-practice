-- INDEX

-- B-tree index 
-- default index type. if a row of a column has null value that will not be indexed. 
-- or if we have a composite index of first and lastnem then if both are null then that row will not be indexed, if one is not null then will be indexed.
-- best suitable on columns having high cardinality (means number of distinct values are more (primary key))
-- unique and non-unique indexes (in unique null values are allowed)
-- function based index. (index created using function ie for username lower is applied on username to avoid case sensitivity)
-- b-tree can have max 32 columns
select * from as_employees;
create index idx_employees_salaryn -- when we dont write anything before index then it is non-unique b-tree index by default
on as_employees(salary);

select e.*, rowid from as_employees e;

-- Bitmap Index  
-- best suitable on column having low cardinality, means the number of distinct values are very less (Gender, dept_id etc)
-- it is best suited for tables where DML operations are less and read operations are more
-- it locks entire bitmap of the values at the time of DML operations on the indexed columns 
create bitmap index bitmap_idx_employees_salary
on as_employees(dept_id);
select * from user_indexes where index_name = 'BITMAP_IDX_EMPLOYEES_SALARY';


/* we havr employees id 1,2,3,null then bitmap will do
1      -->0011  and so on / in this way it will store record for each row in one whole bitmap string
2      -->0100
3      -->0000
null   -->1000
*/


-- Practical on Index
-- identify the type of index and create the index on firstname column of sales_persons table.
-- sol - it has high distinct values so b-tree and diff persons can have same f.name so non-unique
create index idx_sales_persons_firstname
on as_sales_persons(first_name);

-- identify the type of index and create the index on joining_date columnn of sales person table
-- sol - more distint so b-tree, more than one persons can join on same day so non-unique
create index idx_sales_persons_joining_date
on as_sales_persons(joining_date);

-- idntify type of idx and create index on product_name col of products table
-- sol - more distint values so b-tree, product_names are unique so unique index
-- not needed already unique constraint on product_name is present. 

-- Identify and create the index for most executed query - Query is: Sale detail by customer name in the given date range.
create index idx_sales_cust_name_sale_date
on as_sales(customer_name, sale_date); -- this index wont be used if we are just using sale_date but will be used when we are using only cust_name because of column position in creating index.
