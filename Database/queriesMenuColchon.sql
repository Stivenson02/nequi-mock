2 g i. Consultar el dinero guardado en el colchón

SELECT `cushion_money`
FROM `cushions`
WHERE `storage_id` = #{cushion_storage_id};

2 g ii. Agregar dinero disponible al colchón

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, #{sent_money}))
VALUES(#{saving_account_storage_id}, #{cushion_storage_id}, #{sent_money});

UPDATE `savings_accounts`
SET `available_money` = `available_money` - #{sent_money}
WHERE `storage_id` = #{saving_account_storage_id};

UPDATE `cushions`
SET `cushion_money` = `cushion_money` + #{sent_money},
WHERE `storage_id` = #{cushion_storage_id};

2 g iii. Retirar dinero del colchón para que vuelva a estar disponible en la cuenta

INSERT INTO `transactions`(`source_storage_id`, `destination_storage_id`, #{sent_money}))
VALUES(#{cushion_storage_id}, #{saving_account_storage_id}, #{sent_money});

UPDATE `savings_accounts`
SET `available_money` = `available_money` + #{sent_money}
WHERE `storage_id` = #{saving_account_storage_id};

UPDATE `cushions`
SET `cushion_money` = `cushion_money` - #{sent_money},
WHERE `storage_id` = #{cushion_storage_id};