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
-- select * from change_users();