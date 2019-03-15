DROP DATABASE IF EXISTS `nequi_mock`;
CREATE DATABASE `nequi_mock`;
USE `nequi_mock`;

CREATE TABLE `users` (
    `id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` BINARY(64),
    `salt` BINARY(16),
    `registration_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `is_active` BOOLEAN DEFAULT TRUE
);
    
CREATE TABLE `types_of_money_storages` (
    `id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `type_name` VARCHAR(30) NOT NULL
);

CREATE TABLE `money_storages` (
    `id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `type_id` INTEGER NOT NULL REFERENCES types_of_money_storages
);

CREATE TABLE `savings_accounts` (
    `storage_id` INTEGER PRIMARY KEY REFERENCES money_storages,
    `user_id` INTEGER NOT NULL UNIQUE REFERENCES users,
    `available_money` INTEGER NOT NULL DEFAULT 0,
    `total_money` INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE `pockets` (
    `storage_id` INTEGER PRIMARY KEY REFERENCES money_storages,
    `account_id` INTEGER NOT NULL REFERENCES savings_accounts,
    `name` VARCHAR(30) NOT NULL,
    `saved_money` INTEGER NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `is_active` BOOLEAN DEFAULT TRUE
);

CREATE TABLE `goals` (
    `storage_id` INTEGER PRIMARY KEY REFERENCES money_storages,
    `account_id` INTEGER NOT NULL REFERENCES savings_accounts,
    `name` VARCHAR(30) NOT NULL,
    `target_date` DATE NOT NULL,
    `target_money` INTEGER NOT NULL,
    `saved_money` INTEGER NOT NULL DEFAULT 0,
    `was_achieved` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE `cushions` (
    `storage_id` INTEGER PRIMARY KEY REFERENCES money_storages,
    `account_id` INTEGER NOT NULL UNIQUE REFERENCES savings_accounts,
    `cushion_money` INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE `transactions` (
    `id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `source_storage_id` INTEGER REFERENCES money_storages, 
    `destination_storage_id` INTEGER REFERENCES money_storages,
    `money_transferred` INTEGER NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*A continuación se agregan las entradas necesarias en la tabla types_of_money_storages
para identificar los pockets, goals, cushions y savings_accounts*/

INSERT INTO `types_of_money_storages`
VALUES  (1,'savings_account'),
        (2, 'cushion'),
        (3, 'pocket'),
        (4,'goal');

/*Stored procedures*/

/*Users registration*/

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

/*Savings accounts*/

/*2 a. Consultar saldo disponible en su cuenta*/

DROP PROCEDURE IF EXISTS `look_up_available_money`;
DELIMITER //
CREATE PROCEDURE `look_up_available_money`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `available_money` 
    FROM `savings_accounts` WHERE `storage_id` = `savings_account_storage_id`;
    END //
DELIMITER ;

/*2 b. Consultar saldo total en la cuenta*/

DROP PROCEDURE IF EXISTS `look_up_total_money`;
DELIMITER //
CREATE PROCEDURE `look_up_total_money`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `total_money` 
    FROM `savings_accounts` WHERE `storage_id` = `savings_account_storage_id`;
    END //
DELIMITER ;

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

/*2 d. Retirar una cantidad determinada de dinero de su cuenta*/

DROP PROCEDURE IF EXISTS `withdraw_from_savings_account`;
DELIMITER //
CREATE PROCEDURE `withdraw_from_savings_account`(IN `withdrawn_money` INTEGER, IN `savings_account_storage_id` INTEGER)
    BEGIN
    UPDATE `savings_accounts`
    SET `available_money` = `available_money` - `withdrawn_money`,
    `total_money` = `total_money` - `withdrawn_money`
    WHERE `storage_id` = `savings_account_storage_id`;

    INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
    VALUES(`savings_account_storage_id`, NULL, `withdrawn_money`);
    END //
DELIMITER ;

/*2 e. Enviar dinero a otro usuario a través de su email, desde cualquier cuenta de ahorros*/

DROP PROCEDURE IF EXISTS `send_money_from_savings_account_to_another_user_savings_account`;
DELIMITER //
CREATE PROCEDURE `send_money_from_savings_account_to_another_user_savings_account`(IN `recipient_email` VARCHAR(100), IN `sent_money` INTEGER, IN `savings_account_storage_id` INTEGER)
    BEGIN
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

/*Cushions*/

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

/*2 g ii. Agregar dinero disponible al colchón*/

DROP PROCEDURE IF EXISTS `deposit_into_cushion`;
DELIMITER //
CREATE PROCEDURE `deposit_into_cushion`(IN `deposited_money` INTEGER, IN `cushion_storage_id` INTEGER)
    BEGIN
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `cushions`
                        WHERE `storage_id` = `cushion_storage_id`);

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

/*2 g iii. Retirar dinero del colchón para que vuelva a estar disponible en la cuenta*/

DROP PROCEDURE IF EXISTS `withdraw_from_cushion`;
DELIMITER //
CREATE PROCEDURE `withdraw_from_cushion`(IN `withdrawn_money` INTEGER, IN `cushion_storage_id` INTEGER)
    BEGIN
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

/*Pockets*/

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

/*2 h iv. Agregar dinero a un bolsillo*/

DROP PROCEDURE IF EXISTS `deposit_into_pocket`;
DELIMITER //
CREATE PROCEDURE `deposit_into_pocket`(IN `deposited_money` INTEGER, IN `pocket_storage_id` INTEGER)
    BEGIN
    SET @savings_account_storage_id = (SELECT `account_id`
                        FROM `pockets`
                        WHERE `storage_id` = `pocket_storage_id`);

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

/*2 h v. Retirar dinero de un bolsillo*/

DROP PROCEDURE IF EXISTS `withdraw_from_pocket`;
DELIMITER //
CREATE PROCEDURE `withdraw_from_pocket`(IN `withdrawn_money` INTEGER, IN `pocket_storage_id` INTEGER)
    BEGIN
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

/*2 h vi. Enviar dinero de un bolsillo a otro usuario a través de su email*/

DROP PROCEDURE IF EXISTS `send_money_from_pocket_to_another_user_savings_account`;
DELIMITER //
CREATE PROCEDURE `send_money_from_pocket_to_another_user_savings_account`(IN `recipient_email` VARCHAR(100), IN `sent_money` INTEGER, IN `pocket_storage_id` INTEGER)
    BEGIN
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

/*Goals*/

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

/*Transactions history*/

/*2 f. Consultar sus últimas N transacciones (ingresos, retiros, recepciones y envíos)*/

/*Consultar ingresos hacia la cuenta de ahorros propia*/

DROP PROCEDURE IF EXISTS `history_of_personal_deposits_into_savings_account`;
DELIMITER //
CREATE PROCEDURE `history_of_personal_deposits_into_savings_account`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `money_transferred`, `created_at` FROM `transactions`
    WHERE `source_storage_id` IS NULL AND `destination_storage_id` = `savings_account_storage_id`;
    END //
DELIMITER ;

/*Consultar retiros de la cuenta de ahorros propia:*/

DROP PROCEDURE IF EXISTS `history_of_personal_withdrawals_from_savings_account`;
DELIMITER //
CREATE PROCEDURE `history_of_personal_withdrawals_from_savings_account`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `money_transferred`, `created_at` FROM `transactions`
    WHERE `source_storage_id` = `savings_account_storage_id` AND `destination_storage_id` IS NULL;
    END //
DELIMITER ;

/*Consultar recepciones desde cuentas de ahorros de otros usuarios hacia la cuenta de ahorros propia:*/

DROP PROCEDURE IF EXISTS `history_of_deposits_into_sa_from_another_sa`;
DELIMITER //
CREATE PROCEDURE `history_of_deposits_into_sa_from_another_sa`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name` AS `sender_name`, `u`.`email` AS `sender_email`
    FROM `transactions` AS `t`
    JOIN `money_storages` AS `ms`
    ON `ms`.`id` = `t`.`source_storage_id` 
        AND `t`.`destination_storage_id` = `savings_account_storage_id`
        AND `t`.`destination_storage_id` != `t`.`source_storage_id` 
    JOIN `types_of_money_storages` AS `ts`
    ON `ts`.`id` = `ms`.`type_id` AND `ts`.`type_name` = 'savings_account'
    JOIN `savings_accounts` AS `sa`
    ON `ms`.`id` = `sa`.`storage_id`
    JOIN `users` AS `u`
    ON `sa`.`user_id` = `u`.`id`;
    END //
DELIMITER ;

/*Consultar envíos desde la cuenta de ahorros propia hacia las de otros usuarios.*/

DROP PROCEDURE IF EXISTS `history_of_deposits_from_sa_into_another_sa`;
DELIMITER //
CREATE PROCEDURE `history_of_deposits_from_sa_into_another_sa`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name` AS `recipient_name`, `u`.`email` AS `recipient_email`
    FROM `transactions` AS `t`
    JOIN `money_storages` AS `ms`
    ON `ms`.`id` = `t`.`destination_storage_id` 
        AND `t`.`source_storage_id` = `savings_account_storage_id`
    JOIN `types_of_money_storages` AS `ts`
    ON `ts`.`id` = `ms`.`type_id` AND `ts`.`type_name` = 'savings_account'
    JOIN `savings_accounts` AS `sa`
    ON `ms`.`id` = `sa`.`storage_id`
    JOIN `users` AS `u`
    ON `sa`.`user_id` = `u`.`id`;
    END //
DELIMITER ;

/*Consultar envíos desde un bolsillo propio hacia las cuentas de ahorros de otros usuarios.*/

DROP PROCEDURE IF EXISTS `history_of_deposits_from_pockets_into_another_sa`;
DELIMITER //
CREATE PROCEDURE `history_of_deposits_from_pockets_into_another_sa`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name` AS `recipient_name`, `u`.`email` AS `recipient_email`, `p`.`name` AS `pocket_name`
    FROM `transactions` AS `t`
    JOIN `money_storages` AS `ms1`
    ON `ms1`.`id` = `t`.`destination_storage_id` AND `t`.`destination_storage_id` != `savings_account_storage_id`
    JOIN `types_of_money_storages` AS `ts1`
    ON `ts1`.`id` = `ms1`.`type_id` AND `ts1`.`type_name` = 'savings_account'
    JOIN `savings_accounts` AS `sa`
    ON `ms1`.`id` = `sa`.`storage_id`
    JOIN `users` AS `u`
    ON `sa`.`user_id` = `u`.`id`
    JOIN `money_storages` AS `ms2`
    ON `ms2`.`id` = `t`.`source_storage_id`
    JOIN `types_of_money_storages` AS `ts2`
    ON `ts2`.`id` = `ms2`.`type_id` AND `ts2`.`type_name` = 'pocket'
    JOIN `pockets` AS `p`
    ON `ms2`.`id`=`p`.`storage_id` AND `p`.`account_id` = `savings_account_storage_id`;
    END //
DELIMITER ;

/*Consultar recepciones a la cuenta de ahorros propia desde bolsillos de otros usuarios.*/

DROP PROCEDURE IF EXISTS `history_of_deposits_into_sa_from_another_user_pockets`;
DELIMITER //
CREATE PROCEDURE `history_of_deposits_into_sa_from_another_user_pockets`(IN `savings_account_storage_id` INTEGER)
    BEGIN
    SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name` AS `sender_name`, `u`.`email` AS `sender_email`, `p`.`name` AS `pocket_name`
    FROM `transactions` AS `t`
    JOIN `money_storages` AS `ms1`
    ON `ms1`.`id` = `t`.`destination_storage_id` AND `t`.`destination_storage_id` = `savings_account_storage_id`
    JOIN `types_of_money_storages` AS `ts1`
    ON `ts1`.`id` = `ms1`.`type_id` AND `ts1`.`type_name` = 'savings_account'
    JOIN `money_storages` AS `ms2`
    ON `ms2`.`id` = `t`.`source_storage_id`
    JOIN `types_of_money_storages` AS `ts2`
    ON `ts2`.`id` = `ms2`.`type_id` AND `ts2`.`type_name` = 'pocket'
    JOIN `pockets` AS `p`
    ON `ms2`.`id`=`p`.`storage_id`
    JOIN `savings_accounts` AS `sa`
    ON `p`.`account_id` = `sa`.`storage_id` AND `p`.`account_id` != `savings_account_storage_id`
    JOIN `users` AS `u`
    ON `sa`.`user_id` = `u`.`id`;
    END //
DELIMITER ;






