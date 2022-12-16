-- FUNCTION 
-- -- скільки було поїздок у водія
CREATE OR REPLACE FUNCTION get_count_of_orders_by_driver_name(driver_name varchar) RETURNS integer AS $$
	select count(*) from drivers join orders_taxi on drivers.id = orders_taxi.driver_id where drivers.name = driver_name
	group by name; 
$$ LANGUAGE SQL

-- тестування
select * from get_count_of_orders_by_driver_name('driver_1');
select * from get_count_of_orders_by_driver_name('driver_6');

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Procedure
-- створемо процедуру/функцію, яка перебирає за допомогою циклу таблицю users і повертає таблицю з внесеними змінами
-- (першу букву ім'я та прізвища клієнтів переводимо в верхній регістр та додаємо '+38' до номеру телефонa)
CREATE OR REPLACE FUNCTION change_users()
    RETURNS TABLE(user_id int, user_name varchar, user_surname varchar, user_adress varchar, user_email varchar, user_phone varchar) 
AS $$
declare
	user_rec record; 
begin
	for user_rec in (select id, name, surname, adress, email, phone from users)
	loop
		user_id = user_rec.id; 
		user_name = upper(substr(user_rec.name,1,1)) || substr(user_rec.name,2); 
		user_surname = upper(substr(user_rec.surname, 1, 1)) ||substr(user_rec.surname, 2); 
		user_adress = user_rec.adress;
		user_email = user_rec.email;
		user_phone = '+38' || user_rec.phone;
		return next; 
	end loop; 
end;	
$$ LANGUAGE plpgsql;

-- тестування
select * from change_users();
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- trigger
-- створемо trigger, який буде реагувати на зміну та додавання нових даних, 
-- а саме буде записувати в відповідні створені атрибути дату та час та назву юзера, під яким було зроблено зміни

-- спочатку створемо відповідні додаткові атрибути 
ALTER TABLE cars ADD COLUMN user_changed text; 
ALTER TABLE cars ADD COLUMN last_updated timestamp; 


CREATE FUNCTION track_changes_on_cars() RETURNS trigger
AS $$ BEGIN
	NEW.user_changed = session_user; 
	NEW.last_updated = NOW(); 
	RETURN new;
END;$$
LANGUAGE 'plpgsql';


CREATE TRIGGER track_changes_on_cars
BEFORE INSERT OR UPDATE ON cars
FOR EACH ROW
EXECUTE PROCEDURE track_changes_on_cars();

-- тестування
 insert into cars values (11, 'company1', 'model7', 9);
 insert into cars values (12, 'compan2', 'model8', 7);
 update cars set driver_id = 1 where manufacture_name = 'company3'; 
 select * from cars; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 