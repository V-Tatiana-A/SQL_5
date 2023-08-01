USE vk;

-- Получите друзей пользователя с id=1  (решение задачи с помощью представления “друзья”)

CREATE VIEW 1_friends AS
(SELECT fr1.initiator_user_id AS id, CONCAT(u.firstname, " ", u.lastname) AS fullname 
FROM users u, friend_requests fr1 WHERE fr1.status="approved" AND fr1.target_user_id = 1 AND fr1.initiator_user_id=u.id
UNION
SELECT fr2.target_user_id, CONCAT(u.firstname, " ", u.lastname) 
FROM users u, friend_requests fr2 WHERE fr2.status="approved" AND initiator_user_id=1 AND fr2.target_user_id=u.id)
ORDER BY id;

SELECT * FROM 1_friends;


-- Создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id = 1.

CREATE VIEW 1_mess AS
SELECT * FROM messages
WHERE from_user_id=1 OR to_user_id=1;

SELECT * FROM 1_mess;


-- Получите список медиафайлов пользователя с количеством лайков(media m, likes l ,users u)

SELECT u.id, CONCAT(u.firstname, " ", u.lastname) AS fullname, m.id, m.filename AS media_name, COUNT(l.id) AS likes_media
FROM media m
LEFT JOIN likes l ON m.id=l.media_id
JOIN users u ON u.id=m.user_id
GROUP BY u.id, m.id
ORDER BY u.id, m.id;


-- Получите количество групп у пользователей

SELECT u.id, CONCAT(u.firstname, " ", u.lastname) AS fullname, COUNT(uc.community_id) AS num_of_communities
FROM users u, users_communities uc
WHERE u.id=uc.user_id
GROUP BY uc.user_id
ORDER BY uc.user_id;


-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.

CREATE VIEW young AS
SELECT u.firstname, u.lastname, p.hometown, p.gender
FROM users u, profiles p
WHERE u.id=p.user_id;

SELECT * FROM young;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)

SELECT u.id, u.firstname, u.lastname, COUNT(m.id) AS messagec_count, DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS `rank`
FROM users u, messages m
WHERE u.id=m.from_user_id
GROUP BY u.id;


-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) 
-- и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)

SELECT id, from_user_id, to_user_id, body, created_at, DATEDIFF(LEAD(created_at) OVER(), created_at) AS days_passed
FROM messages
ORDER BY created_at;
