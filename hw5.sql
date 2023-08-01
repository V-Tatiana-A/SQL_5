CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;


-- 1. Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов

CREATE VIEW cheap_cars AS
SELECT * FROM cars
WHERE cost<25000;

SELECT * FROM cheap_cars;


-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор OR REPLACE)

CREATE OR REPLACE VIEW cheap_cars AS
SELECT * FROM cars
WHERE cost<30000;

SELECT * FROM cheap_cars;


-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”

CREATE VIEW SkAudi AS
SELECT * FROM cars
WHERE name IN ('Skoda', 'Audi');

SELECT * FROM SkAudi;

/*
4. Добавьте новый столбец под названием «время до следующей станции». 
Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. 
Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, 
чтобы получить результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
*/

CREATE TABLE IF NOT EXISTS trains
(
	train_id INT,
    station VARCHAR(20),
    station_time TIME
);

INSERT INTO trains (train_id, station, station_time)
VALUES
	(110, "San Francisco", "10:00:00"),
    (110, "Redwood city", "10:54:00"),
    (110, "Palo Alto", "11:02:00"),
    (110, "San Jose", "12:35:00"),
	(120, "San Francisco", "11:00:00"),
    (120, "Palo Alto", "12:49:00"),
    (120, "San Jose", "13:30:00");
    
SELECT * FROM trains;


/*
SELECT train_id, station, station_time, CAST(-station_time + LEAD(station_time) OVER(PARTITION BY train_id) AS TIME) AS time_to_next_station
FROM trains;
-- почему-то при форматировании через cast не отображается разница по отправлению в 12:49
*/


ALTER TABLE trains ADD time_to_next_station TIME;

UPDATE trains 
JOIN (SELECT train_id, station, TIMEDIFF(LEAD(station_time) OVER(PARTITION BY train_id), station_time) AS time_to_next_station FROM trains) AS `time`
ON trains.train_id=`time`.train_id AND trains.station=`time`.station
SET trains.time_to_next_station=`time`.time_to_next_station;

SELECT * FROM trains;