/*1. Registrar usuario con su nombre, email y contraseña*/

DROP PROCEDURE IF EXISTS `register_user`;
DELIMITER //
CREATE PROCEDURE `register_user`(IN `new_name` VARCHAR(100), IN `new_email` VARCHAR(100), IN `new_password` VARCHAR(100))
    BEGIN

    SET @salt = UNHEX(MD5(RAND()));
    
    INSERT INTO `users`(`name`, `email`, `salt`) 
    VALUES(`new_name`, `new_email`, @salt);

    SET @user_id = LAST_INSERT_ID();

    UPDATE `users` SET `password_hash` = UNHEX(SHA2(CONCAT(`new_password`,@salt),512)) WHERE `id` = @user_id;

    INSERT INTO `money_storages`(`type_id`) 
    VALUES((SELECT `ts`.`id` FROM `types_of_money_storages` AS `ts` 
    WHERE `ts`.`type_name` = 'savings_account'));

    SET @savings_account_storage_id = LAST_INSERT_ID();

    INSERT INTO `savings_accounts`(`storage_id`, `user_id`)
    VALUES(@savings_account_storage_id, @user_id);

    INSERT INTO `money_storages`(`type_id`) 
    VALUES((SELECT `ts`.`id` FROM `types_of_money_storages` AS `ts` 
    WHERE `ts`.`type_name` = 'cushion'));

    SET @cushion_storage_id = LAST_INSERT_ID();

    INSERT INTO `cushions`(`storage_id`, `account_id`)
    VALUES(@cushion_storage_id, @savings_account_storage_id);
    END //
DELIMITER ;

/*Query to call procedure
CALL `register_user`('#{name}','#{email}','#{password}');
*/

/*2. Login*/

DROP PROCEDURE IF EXISTS `login`;
DELIMITER //
CREATE PROCEDURE `login`(IN `user_email` VARCHAR(100), IN `user_password` VARCHAR(100))
    BEGIN 
    SELECT `u`.`name`, `u`.`id` AS 'user_id', `sa`.`storage_id` AS 'savings_account_storage_id', `c`.`storage_id` AS 'cushion_storage_id' 
    FROM  `users` AS `u`
    JOIN `savings_accounts` AS `sa`
    ON `sa`.`user_id` = `u`.`id`
    JOIN `cushions` AS `c`
    ON `c`.`account_id` = `sa`.`storage_id` 
    WHERE `u`.`email` = `user_email` AND UNHEX(SHA2(CONCAT(`user_password`, `u`.`salt`), 512)) = `u`.`password_hash`;
    END//
DELIMITER ;

/*Query to call procedure
CALL `login`('#{email}', '#{password}');
*/