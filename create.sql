DROP TABLE IF EXISTS orders_taxi;
DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS drivers;

create table users(
	id int, 
	name varchar(32) not null, 
	surname varchar(32) not null, 
	adress varchar(64) not null, 
	email varchar(64) not null, 
	phone varchar(64) not null
);

create table orders_taxi(
	id int,
	order_date date not null, 
	user_id int not null,  
	driver_id int not null
);

create table drivers(
	id int, 
	name varchar(32) not null, 
	surname varchar(32) not null,
	phone_number varchar(50) not null, 
	email varchar(50) not null,
	rating float
); 


create table cars(
	id int,
	manufacture_name varchar(100) not null, 
	model_name varchar(100) not null,
	driver_id int not null
);


alter table users add primary key(id); 
alter table orders_taxi add primary key(id);
alter table drivers add primary key(id); 
alter table cars add primary key(id); 
 
alter table orders_taxi add foreign key(user_id) references users(id);
alter table cars add foreign key(driver_id) references drivers(id);
alter table orders_taxi add foreign key(driver_id) references drivers(id);





