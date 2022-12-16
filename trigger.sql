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
-- insert into cars values (11, 'company1', 'model7', 9);
-- insert into cars values (12, 'compan2', 'model8', 7);
-- update cars set driver_id = 1 where manufacture_name = 'company3'; 

-- select * from cars; 