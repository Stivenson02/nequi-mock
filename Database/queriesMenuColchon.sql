2 g i. Consultar el dinero guardado en el colchón

SELECT `cushion_money`
FROM `cushions`
WHERE `storage_id` = #{cushion_storage_id};

2 g ii. Agregar dinero disponible al colchón

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{savings_account_storage_id}, #{cushion_storage_id}, #{deposited_money_into_cushion});

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{deposited_money_into_cushion}
WHERE `storage_id` = #{savings_account_storage_id};

UPDATE `cushions`
SET `cushion_money` = `cushion_money` + #{deposited_money_into_cushion}
WHERE `storage_id` = #{cushion_storage_id};

2 g iii. Retirar dinero del colchón para que vuelva a estar disponible en la cuenta

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, `money_transferred`)
VALUES(#{cushion_storage_id}, #{savings_account_storage_id}, #{withdrawn_money_from_cushion});

UPDATE `savings_accounts`
SET `available_money` = `available_money` + #{withdrawn_money_from_cushion}
WHERE `storage_id` = #{savings_account_storage_id};

UPDATE `cushions`
SET `cushion_money` = `cushion_money` - #{withdrawn_money_from_cushion}
WHERE `storage_id` = #{cushion_storage_id};