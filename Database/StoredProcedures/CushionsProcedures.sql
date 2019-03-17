/*2 g i. Consultar el dinero guardado en el colchón*/

DROP PROCEDURE IF EXISTS `look_up_cushion_money`;
DELIMITER //
CREATE PROCEDURE `look_up_cushion_money`(IN `cushion_storage_id` INTEGER)
    BEGIN
    SELECT `cushion_money`
    FROM `cushions`
    WHERE `storage_id` = `cushion_storage_id`;
    END//
DELIMITER ;

/*Query to call procedure
CALL `look_up_cushion_money`(#{cushion_storage_id});
*/

/*2 g ii. Agregar dinero disponible al colchón*/

DROP PROCEDURE IF EXISTS `deposit_into_cushion`;
DELIMITER //
CREATE PROCEDURE `deposit_into_cushion`(IN `deposited_money` INTEGER, IN `cushion_storage_id` INTEGER)
    BEGIN
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `cushions`
                        WHERE `storage_id` = `cushion_storage_id`);

    IF (SELECT `available_money` FROM `savings_accounts` WHERE `storage_id` = @savings_account_storage_id) < `deposited_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Deposited money can\'t be greater than the available money in the savings account';
    END IF;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(@savings_account_storage_id, `cushion_storage_id`, `deposited_money`);

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` - `deposited_money`
    WHERE `storage_id` = @savings_account_storage_id;

    UPDATE `cushions`
    SET `cushion_money` = `cushion_money` + `deposited_money`
    WHERE `storage_id` = `cushion_storage_id`;
    END //
DELIMITER ;

/*Query to call procedure
CALL `deposit_into_cushion`(#{deposited_money}, #{cushion_storage_id});
*/

/*2 g iii. Retirar dinero del colchón para que vuelva a estar disponible en la cuenta*/

DROP PROCEDURE IF EXISTS `withdraw_from_cushion`;
DELIMITER //
CREATE PROCEDURE `withdraw_from_cushion`(IN `withdrawn_money` INTEGER, IN `cushion_storage_id` INTEGER)
    BEGIN
    IF (SELECT `cushion_money` FROM `cushions` WHERE `storage_id` = `cushion_storage_id`) < `withdrawn_money` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Withdrawn money can\'t be greater than the money stored in the cushion';
    END IF;
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `cushions`
                        WHERE `storage_id` = `cushion_storage_id`);

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(`cushion_storage_id`, @savings_account_storage_id, `withdrawn_money`);

    UPDATE `savings_accounts`
    SET `available_money` = `available_money` + `withdrawn_money`
    WHERE `storage_id` = @savings_account_storage_id;

    UPDATE `cushions`
    SET `cushion_money` = `cushion_money` - `withdrawn_money`
    WHERE `storage_id` = `cushion_storage_id`;
    END //
DELIMITER ;

/*Query to call procedure
CALL `withdraw_from_cushion`(#{withdrawn_money}, #{cushion_storage_id});
*/
