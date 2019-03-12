2 i i. Listar la información de todas sus metas: nombre, monto total, dinero ahorrado, dinero restante para cumplir la meta, el estado actual (cumplida o vencida) y la fecha límite.

SELECT `name`, `target_money`, `saved_money`, `target_money`-`saved_money` AS `remaining_money`, `was_achieved`, CURRENT_TIMESTAMP < `target_date`, `target_date`
FROM `goals`
WHERE `account_id` = #{savings_account_storage_id}

2 i ii. Crear una nueva meta. Nombre, monto total y fecha límite.

INSERT INTO `money_storages`(`type_id`) 
VALUES((SELECT `ts`.`id` FROM `type_of_storage` AS `ts` 
WHERE `ts`.`type_name` = 'goal'));

SET @goal_storage_id = (SELECT LAST_INSERT_ID());

INSERT INTO `goals`(`storage_id`,`account_id`,`name`,`target_date`,`target_money`)
VALUES(@goal_storage_id, #{savings_account_storage_id}, #{goal_name}, #{target_date}, #{target_money});

2 i iii. Cerrar una meta. Esto implica que el dinero que está en dicha meta vuelve a estar disponible en la cuenta de ahorros.

SET @goal_money = SELECT `saved_money` FROM `goals` WHERE `storage_id` = #{goal_storage_id};

UPDATE `goal`
SET `saved_money` = 0, `deleted_at` = CURRENT_TIMESTAMP, `is_active` = FALSE
WHERE `storage_id` = #{goal_storage_id};

UPDATE `savings_accounts`
SET `saved_money` = `saved_money` + @goal_money
WHERE `storage_id` = #{savings_account_storage_id};

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{goal_storage_id}, #{savings_account_storage_id}, @goal_money);


2 i iv. Agregar dinero a una meta

UPDATE `goals`
SET `saved_money` = `saved_money` + #{deposited_money_into_goal}
WHERE `storage_id` = #{goal_storage_id};

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{deposited_money_into_goal}
WHERE `storage_id` = #{savings_account_storage_id};

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{savings_account_storage_id}, #{goal_storage_id}, #{deposited_money_into_goal});



