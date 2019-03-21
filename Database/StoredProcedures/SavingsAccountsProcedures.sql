/*2 a. Consultar saldo disponible en su cuenta*/

DROP PROCEDURE IF EXISTS `look_up_available_money`;
DELIMITER //
CREATE PROCEDURE `look_up_available_money`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `available_money` 
    FROM `savings_accounts` WHERE `storage_id` = `savings_account_storage_id`;
    END //
DELIMITER ;

/*Query to call procedure
CALL `look_up_available_money`(#{savings_account_storage_id});
*/

/*2 b. Consultar saldo total en la cuenta*/

DROP PROCEDURE IF EXISTS `look_up_total_money`;
DELIMITER //
CREATE PROCEDURE `look_up_total_money`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `total_money` 
    FROM `savings_accounts` WHERE `storage_id` = `savings_account_storage_id`;
    END //
DELIMITER ;

/*Query to call procedure
CALL `look_up_total_money`(#{savings_account_storage_id});
*/

/*2 c. Ingresar una cantidad determinada de dinero a su cuenta*/

DROP PROCEDURE IF EXISTS`deposit_into_savings_account`;
DELIMITER //
CREATE PROCEDURE `deposit_into_savings_account`(IN `deposited_money` INTEGER, IN `savings_account_storage_id` INTEGER)
    BEGIN
    UPDATE `savings_accounts`
    SET `available_money` = `available_money` + `deposited_money`,
    `total_money` = `total_money` + `deposited_money`
    WHERE `storage_id` = `savings_account_storage_id`;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(NULL, `savings_account_storage_id`, `deposited_money`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `deposit_into_savings_account`(#{deposited_money}, #{savings_account_storage_id});
*/

/*2 d. Retirar una cantidad determinada de dinero de su cuenta*/

DROP PROCEDURE IF EXISTS `withdraw_from_savings_account`;
DELIMITER //
CREATE PROCEDURE `withdraw_from_savings_account`(IN `withdrawn_money` INTEGER, IN `savings_account_storage_id` INTEGER)
    BEGIN
    IF (SELECT `available_money` FROM `savings_accounts` WHERE `storage_id` = `savings_account_storage_id`) < `withdrawn_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Withdrawn money can\'t be greater than the available money in the savings account';
    END IF;
    UPDATE `savings_accounts`
    SET `available_money` = `available_money` - `withdrawn_money`,
    `total_money` = `total_money` - `withdrawn_money`
    WHERE `storage_id` = `savings_account_storage_id`;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(`savings_account_storage_id`, NULL, `withdrawn_money`);
    END //
DELIMITER ;

/*Query to call procedure
CALL `withdraw_from_savings_account`(#{withdrawn_money}, #{savings_account_storage_id});
*/

/*2 e. Enviar dinero a otro usuario a través de su email, desde cualquier cuenta de ahorros*/

DROP PROCEDURE IF EXISTS `send_money_from_savings_account_to_another_user_savings_account`;
DELIMITER //
CREATE PROCEDURE `send_money_from_savings_account_to_another_user_savings_account`(IN `recipient_email` VARCHAR(100), IN `sent_money` INTEGER, IN `savings_account_storage_id` INTEGER)
    BEGIN
    IF (SELECT `available_money` FROM `savings_accounts` WHERE `storage_id` = `savings_account_storage_id`) < `sent_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sent money can\'t be greater than the available money in the savings account';
    END IF;
    SET @destination_user_id = (SELECT `id` 
                                FROM `users` 
                                WHERE `email` = `recipient_email`);

    SET @destination_storage_id = (SELECT `storage_id`
                        FROM `savings_accounts`
                        WHERE `user_id` = @destination_user_id);

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(`savings_account_storage_id`, @destination_storage_id, `sent_money`);

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` - `sent_money`,
        `total_money` = `total_money` - `sent_money`
    WHERE `storage_id` = `savings_account_storage_id`;

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` + `sent_money`,
    `total_money` = `total_money` + `sent_money`
    WHERE `storage_id` = @destination_storage_id;
    END //
DELIMITER ;

/*Query to call procedure
CALL `send_money_from_savings_account_to_another_user_savings_account`('#{recipient_email}', #{sent_money}, #{savings_account_storage_id})
*/

/*Checks if email exists*/

DROP PROCEDURE IF EXISTS `email_exists`;
DELIMITER //
CREATE PROCEDURE `email_exists`(IN `user_email` VARCHAR(100))
    BEGIN 
	SET @val = (SELECT COUNT(`id`) FROM `users` WHERE `email` = `user_email` GROUP BY `id`);
    IF @val IS NULL THEN
		SELECT 0 AS `exists`;
	ELSE
		SELECT 1 AS `exists`;
	END IF;
    END//
DELIMITER ;

/*Query to call procedure
CALL `email_exists`(#{email})
*/