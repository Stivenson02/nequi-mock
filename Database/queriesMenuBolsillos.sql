2 h i. Listar información de todos sus bolsillos (nombre y saldo)

SELECT `name`, `saved_money`
FROM `pockets`
WHERE `account_id` = #{savings_account_storage_id}

2 h ii. Crear un bolsillo nuevo. EL bolsillo se crea con un nombre y saldo de 0

INSERT INTO `money_storages`(`type_id`) 
VALUES((SELECT `ts`.`id` FROM `type_of_storage` AS `ts` 
WHERE `ts`.`type_name` = 'pocket'));

SET @pocket_storage_id = (SELECT LAST_INSERT_ID());

INSERT INTO `pockets`(`storage_id`, `account_id`, `name`)
VALUES(@pocket_storage_id, #{savings_account_storage_id}, #{pocket_name});

2 h iii. Elimina un bolsillo. Esto implica que el dinero que está en dicho bolsillo vuelve a estar disponible en la cuenta del usuario

SET @pocket_money = (SELECT `saved_money` FROM `pockets` WHERE `storage_id`=#{pocket_storage_id});

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{pocket_storage_id}, #{savings_account_storage_id}, @pocket_money);

UPDATE `pockets`
SET `saved_money` = 0, `deleted_at` = CURRENT_TIMESTAMP, `is_active` = FALSE
WHERE `storage_id` = #{pocket_storage_id};

UPDATE `savings_accounts`
SET `available_money` = `available_money` + @pocket_money
WHERE `storage_id` = #{savings_account_storage_id};

2 h iv. Agregar dinero a un bolsillo

UPDATE `pockets`
SET `saved_money` = `saved_money` + #{deposited_money_into_pocket}
WHERE `storage_id` = `pocket_storage_id`

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{deposited_money_into_pocket},
WHERE `storage_id` = #{savings_account_storage_id};

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{savings_account_storage_id}, #{pocket_storage_id}, #{deposited_money_into_pocket});

2 h v. Retirar dinero de un bolsillo

UPDATE `pockets`
SET `saved_money` = `saved_money` - #{withdrawn_money_from_goal}
WHERE `storage_id` = `pocket_storage_id`

UPDATE `savings_accounts`
SET `available_money` = `available_money` + #{withdrawn_money_from_goal}
WHERE `storage_id` = #{savings_account_storage_id};

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{pocket_storage_id}, #{savings_account_storage_id}, #{withdrawn_money_from_goal});

2 h vi. Enviar dinero de un bolsillo a otro usuario a través de su email

SET @destination_user_id = (SELECT `id` 
                            FROM `users` 
                            WHERE `email` = #{email});

SET @destination_storage_id = SELECT `storage_id`
                      FROM `savings_accounts`
                      WHERE `user_id` = @destination_user_id;

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{pocket_storage_id}, @destination_storage_id, #{sent_money});

UPDATE `pockets`
SET `saved_money` = `saved_money` - #{sent_money}
WHERE `storage_id` = `pocket_storage_id`

UPDATE `savings_accounts`
SET `total_money` = `total_money` - #{sent_money}
WHERE `storage_id` = #{savings_account_storage_id};

UPDATE `savings_accounts`
SET `total_money` = `total_money` - #{sent_money}
WHERE `storage_id` = @destination_storage_id;
