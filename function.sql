-- FUNCTION 
-- -- скільки було поїздок у водія
CREATE OR REPLACE FUNCTION get_count_of_orders_by_driver_name(driver_name varchar) RETURNS integer AS $$
	select count(*) from drivers join orders_taxi on drivers.id = orders_taxi.driver_id where drivers.name = driver_name
	group by name; 
$$ LANGUAGE SQL

-- тестування
--select * from get_count_of_orders_by_driver_name('driver_1');
--select * from get_count_of_orders_by_driver_name('driver_6');