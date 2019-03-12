1. Registrar usuario con su nombre, email y contraseña

INSERT INTO `users`(`name`, `email`, `password`) 
VALUES(#{name}, #{email}, #{password});

SET @user_id = (SELECT LAST_INSERT_ID());

INSERT INTO `money_storages`(`type_id`) 
VALUES((SELECT `ts`.`id` FROM `types_of_money_storages` AS `ts` 
WHERE `ts`.`type_name` = 'savings_account'));

SET @savings_account_storage_id = (SELECT LAST_INSERT_ID());

INSERT INTO `savings_accounts`(`storage_id`, `user_id`)
VALUES(@savings_account_storage_id, @user_id);

INSERT INTO `money_storages`(`type_id`) 
VALUES((SELECT `ts`.`id` FROM `types_of_money_storages` AS `ts` 
WHERE `ts`.`type_name` = 'cushion'));

SET @cushion_storage_id = (SELECT LAST_INSERT_ID());

INSERT INTO `cushions`(`storage_id`, `account_id`)
VALUES(@cushion_storage_id, @savings_account_storage_id);

SELECT @user_id, @savings_account_storage_id, @cushion_storage_id;