USE sakila;

### 1.Write a query to find what is the total business done by each store.
select * from payment;
select * from staff;

select s.store_id , sum(p.amount) as total_business_done from payment p
join
staff s on p.staff_id = s.staff_id
group by 1;

### 2.Convert the previous query into a stored procedure.

drop procedure if exists business;

DELIMITER $$
Create Procedure business(out param1 varchar(20))
Begin
select s.store_id , sum(p.amount) as total_business_done from payment p
join
staff s on p.staff_id = s.staff_id
group by 1;

END $$

-- Calling stored procedure
DELIMITER ;
call business(@z);

### 3.Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists business_store_;

DELIMITER $$
Create Procedure business_store(in param1 int)
Begin
select s.store_id , sum(p.amount) as total_business_done from payment p
join
staff s on p.staff_id = s.staff_id
where s.store_id = param1
group by s.store_id;


END $$

-- Calling stored procedure
DELIMITER ;
call business_store(1);

### 4.Update the previous query.
### Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store).
### Call the stored procedure and print the results.

drop procedure if exists business_store_variable;

DELIMITER $$
Create Procedure business_store_variable(in param1 int)
Begin
declare total_business_done float default 0;
select sum(p.amount) into total_business_done from payment p
join
staff s on p.staff_id = s.staff_id
where s.store_id = param1
group by s.store_id;
select total_business_done;
END $$

-- Calling stored procedure
DELIMITER ;
call business_store_variable(1);


### 5.In the previous query, add another variable flag. If the total sales value for the store is over 30.000,
### then label it as green_flag, otherwise label is as red_flag.
### Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

drop procedure if exists business_store_variable_flag;

DELIMITER $$
Create Procedure business_store_variable_flag(in param1 int)
Begin
declare total_business_done float default 0;
declare flag varchar(10) default ' ';

select  sum(p.amount) into total_business_done 
from payment p
join
staff s on p.staff_id = s.staff_id
where s.store_id = param1
group by s.store_id ;

select (case when total_business_done > 30000 then 'Red' else 'Green' end) into flag;

select total_business_done,flag;

END $$

-- Calling stored procedure
DELIMITER ;
call business_store_variable_flag(1);




