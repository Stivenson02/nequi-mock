2 a. Consultar saldo disponible en su cuenta

SELECT `available_money` 
FROM `savings_accounts` WHERE `storage_id` = #{saving_account_storage_id};

2 b. Consultar saldo total en la cuenta

SELECT `total_money` 
FROM `savings_accounts` WHERE `storage_id` = #{saving_account_storage_id};

2 c. Ingresar una cantidad determinada de dinero a su cuenta

UPDATE `savings_accounts`
SET `available_money` = `available_money` + #{deposited_money},
`total_money` = `total_money` + #{deposited_money}
WHERE `storage_id` = #{saving_account_storage_id};

2 d. Retirar una cantidad determinada de dinero de su cuenta

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, #{withdrawn_money})
VALUES(#{money_storage_id}, NULL, #{withdrawn_money});

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{withdrawn_money},
    `total_money` = `total_money` - #{withdrawn_money}
WHERE `storage_id` = #{saving_account_storage_id};

2 e. Enviar dinero a otro usuario a través de su email, desde cualquier cuenta de ahorros

SET @destination_user_id = (SELECT `id` 
                            FROM `users` 
                            WHERE `email` = #{email});

SET @destination_storage_id = SELECT `storage_id`
                      FROM `savings_accounts`
                      WHERE `user_id` = @destination_user_id;

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, #{sent_money}))
VALUES(#{saving_account_storage_id}, @destination_storage_id, #{sent_money});

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{sent_money},
    `total_money` = `total_money` - #{sent_money}
WHERE `storage_id` = #{saving_account_storage_id};

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{sent_money}
`total_money` = `total_money` - #{sent_money}
WHERE `storage_id` = @destination_storage_id;

2 f. Consultar sus últimas N transacciones (ingresos, retiros, recepciones y envíos)