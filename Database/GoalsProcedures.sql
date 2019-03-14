/*2 i i. Listar la información de todas sus metas: nombre, monto total, dinero ahorrado, dinero restante para cumplir la meta, el estado actual (cumplida o vencida) y la fecha límite.*/

DROP PROCEDURE IF EXISTS `list_goals`;
DELIMITER //
CREATE PROCEDURE `list_goals`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `storage_id`, `name`, `target_money`, `saved_money`, (SELECT GREATEST(`target_money`-`saved_money`, 0)) AS `remaining_money`, 
    `was_achieved`, CURRENT_TIMESTAMP > `target_date` AS `expired`, `target_date`
    FROM `goals`
    WHERE `account_id` = `savings_account_storage_id` AND `is_active` = 1;
    END //
DELIMITER ;

/*Query to call procedure
CALL `list_goals`(#{savings_account_storage_id});
*/

/*2 i ii. Crear una nueva meta. Nombre, monto total y fecha límite.*/

DROP PROCEDURE IF EXISTS `create_goal`;
DELIMITER //
CREATE PROCEDURE `create_goal`(IN `goal_name` VARCHAR(30), IN `target_date` DATE, IN `target_money` INTEGER, IN `savings_account_storage_id` INTEGER)
    BEGIN
    INSERT INTO `money_storages`(`type_id`) 
    VALUES((SELECT `ts`.`id` FROM `types_of_money_storages` AS `ts` 
    WHERE `ts`.`type_name` = 'goal'));

    SET @goal_storage_id = (SELECT LAST_INSERT_ID());

    INSERT INTO `goals`(`storage_id`,`account_id`,`name`,`target_date`,`target_money`)
    VALUES(@goal_storage_id, `savings_account_storage_id`, `goal_name`, `target_date`, `target_money`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `create_goal`('#{goal_name}', '#{target_date}', #{target_money}, #{savings_account_storage_id});
*/

/*2 i iii. Cerrar una meta. Esto implica que el dinero que está en dicha meta vuelve a estar disponible en la cuenta de ahorros.*/

DROP PROCEDURE IF EXISTS `delete_goal`;
DELIMITER //
CREATE PROCEDURE `delete_goal`(IN `goal_storage_id` INTEGER)
    BEGIN
    SET @goal_money = (SELECT `saved_money` FROM `goals` WHERE `storage_id` = `goal_storage_id`);

    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `goals`
                        WHERE `storage_id` = `goal_storage_id`);

    UPDATE `goals`
    SET `saved_money` = 0, `deleted_at` = CURRENT_TIMESTAMP, `is_active` = FALSE
    WHERE `storage_id` = `goal_storage_id`;

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` + @goal_money
    WHERE `storage_id` = @savings_account_storage_id;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    SELECT `goal_storage_id`, @savings_account_storage_id, @goal_money WHERE @goal_money != 0;
    END //
DELIMITER ;

/*Query to call procedure
CALL `delete_goal`(#{goal_storage_id});
*/



/*2 i iv. Agregar dinero a una meta*/

DROP PROCEDURE IF EXISTS `deposit_into_goal`;
DELIMITER //
CREATE PROCEDURE `deposit_into_goal`(IN `deposited_money` INTEGER, IN `goal_storage_id` INTEGER)
    BEGIN
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `goals`
                        WHERE `storage_id` = `goal_storage_id`);

    UPDATE `goals`
    SET `saved_money` = `saved_money` + `deposited_money`
    WHERE `storage_id` = `goal_storage_id`;

    UPDATE `goals`
    SET `was_achieved` = 1
    WHERE `storage_id` = `goal_storage_id` AND `saved_money` >= `target_money`;

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` - `deposited_money`
    WHERE `storage_id` = @savings_account_storage_id;


    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(@savings_account_storage_id, `goal_storage_id`, `deposited_money`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `deposit_into_goal`(#{deposited_money}, #{goal_storage_id});
*/




