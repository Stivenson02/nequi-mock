/*2 h i. Listar información de todos sus bolsillos (nombre y saldo)*/

DROP PROCEDURE IF EXISTS `list_pockets`;
DELIMITER //
CREATE PROCEDURE `list_pockets`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `storage_id`, `name`, `saved_money`
    FROM `pockets`
    WHERE `account_id` = `savings_account_storage_id` AND `is_active` = 1;
    END //
DELIMITER ;

/*Query to call procedure
CALL `list_pockets`(#{savings_account_storage_id});
*/

/*2 h ii. Crear un bolsillo nuevo. EL bolsillo se crea con un nombre y saldo de 0*/

DROP PROCEDURE IF EXISTS `create_pocket`;
DELIMITER //
CREATE PROCEDURE `create_pocket`(IN `pocket_name` VARCHAR(30), IN `savings_account_storage_id` INTEGER)
    BEGIN
    INSERT INTO `money_storages`(`type_id`) 
    VALUES((SELECT `ts`.`id` FROM `types_of_money_storages` AS `ts` 
    WHERE `ts`.`type_name` = 'pocket'));

    SET @pocket_storage_id = (SELECT LAST_INSERT_ID());

    INSERT INTO `pockets`(`storage_id`, `account_id`, `name`)
    VALUES(@pocket_storage_id, `savings_account_storage_id`, `pocket_name`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `create_pocket`(#{pocket_name}, #{savings_account_storage_id});
*/

/*2 h iii. Elimina un bolsillo. Esto implica que el dinero que está en dicho bolsillo vuelve a estar disponible en la cuenta del usuario*/

DROP PROCEDURE IF EXISTS `delete_pocket`;
DELIMITER //
CREATE PROCEDURE `delete_pocket`(IN `pocket_storage_id` INTEGER)
    BEGIN
    SET @pocket_money = (SELECT `saved_money` FROM `pockets` WHERE `storage_id`=`pocket_storage_id`);
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `pockets`
                        WHERE `storage_id` = `pocket_storage_id`);

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    SELECT `pocket_storage_id`, @savings_account_storage_id, @pocket_money WHERE @pocket_money != 0;

    UPDATE `pockets`
    SET `saved_money` = 0, `deleted_at` = CURRENT_TIMESTAMP, `is_active` = FALSE
    WHERE `storage_id` = `pocket_storage_id`;

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` + @pocket_money
    WHERE `storage_id` = @savings_account_storage_id;
    END //
DELIMITER ;

/*Query to call procedure
CALL `delete_pocket`(#{pocket_storage_id});
*/

/*2 h iv. Agregar dinero a un bolsillo*/

DROP PROCEDURE IF EXISTS `deposit_into_pocket`;
DELIMITER //
CREATE PROCEDURE `deposit_into_pocket`(IN `deposited_money` INTEGER, IN `pocket_storage_id` INTEGER)
    BEGIN
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `pockets`
                        WHERE `storage_id` = `pocket_storage_id`);
    IF (SELECT `available_money` FROM `savings_accounts` WHERE `storage_id` = @savings_account_storage_id) < `deposited_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Deposited money can\'t be greater than the available money in the savings account';
    END IF;
    UPDATE `pockets`
    SET `saved_money` = `saved_money` + `deposited_money`
    WHERE `storage_id` = `pocket_storage_id`;

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` - `deposited_money`
    WHERE `storage_id` = @savings_account_storage_id;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(@savings_account_storage_id, `pocket_storage_id`, `deposited_money`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `deposit_into_pocket`(#{deposited_money}, #{pocket_storage_id});
*/

/*2 h v. Retirar dinero de un bolsillo*/

DROP PROCEDURE IF EXISTS `withdraw_from_pocket`;
DELIMITER //
CREATE PROCEDURE `withdraw_from_pocket`(IN `withdrawn_money` INTEGER, IN `pocket_storage_id` INTEGER)
    BEGIN
    IF (SELECT `saved_money` FROM `pockets` WHERE `storage_id` = `pocket_storage_id`) < `withdrawn_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Withdrawn money can\'t be greater than the money stored in the pocket';
    END IF;
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `pockets`
                        WHERE `storage_id` = `pocket_storage_id`);

    UPDATE `pockets`
    SET `saved_money` = `saved_money` - `withdrawn_money`
    WHERE `storage_id` = `pocket_storage_id`;

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` + `withdrawn_money`
    WHERE `storage_id` = @savings_account_storage_id;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(`pocket_storage_id`, @savings_account_storage_id, `withdrawn_money`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `withdraw_from_pocket`(#{withdrawn_money}, #{pocket_storage_id});
*/

/*2 h vi. Enviar dinero de un bolsillo a otro usuario a través de su email*/

DROP PROCEDURE IF EXISTS `send_money_from_pocket_to_another_user_savings_account`;
DELIMITER //
CREATE PROCEDURE `send_money_from_pocket_to_another_user_savings_account`(IN `recipient_email` VARCHAR(100), IN `sent_money` INTEGER, IN `pocket_storage_id` INTEGER)
    BEGIN
    IF (SELECT `saved_money` FROM `pockets` WHERE `storage_id` = `pocket_storage_id`) < `sent_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sent money can\'t be greater than the money stored in the pocket';
    END IF;
    SET @destination_user_id = (SELECT `id` 
                                FROM `users` 
                                WHERE `email` = `recipient_email`);

    SET @destination_storage_id = (SELECT `storage_id`
                        FROM `savings_accounts`
                        WHERE `user_id` = @destination_user_id);

    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `pockets`
                        WHERE `storage_id` = `pocket_storage_id`);

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(`pocket_storage_id`, @destination_storage_id, `sent_money`);

    UPDATE `pockets`
    SET `saved_money` = `saved_money` - `sent_money`
    WHERE `storage_id` = `pocket_storage_id`;

    UPDATE `savings_accounts`
    SET `total_money` = `total_money` - `sent_money`
    WHERE `storage_id` = @savings_account_storage_id;

    UPDATE `savings_accounts`
    SET `total_money` = `total_money` + `sent_money`,
        `available_money` = `available_money` + `sent_money`
    WHERE `storage_id` = @destination_storage_id;
    END //
DELIMITER ;

/*Query to call procedure
CALL `send_money_from_pocket_to_another_user_savings_account`('#{recipient_email}', #{sent_money}, #{pocket_storage_id});
*/

