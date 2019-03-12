2 f. Consultar sus últimas N transacciones (ingresos, retiros, recepciones y envíos)

#Consultar ingresos hacia la cuenta de ahorros propia:

SELECT `money_transferred`, `created_at` FROM `transactions`
WHERE `source_storage_id` IS NULL AND `destination_storage_id` = #{savings_account_storage_id};

#Consultar retiros de la cuenta de ahorros propia:

SELECT `money_transferred`, `created_at` FROM `transactions`
WHERE `source_storage_id` = #{savings_account_storage_id} AND `destination_storage_id` IS NULL;

#Consultar recepciones desde cuentas de ahorros de otros usuarios hacia la cuenta de ahorros propia:

SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name`, `u`.`email` 
FROM `transactions` AS `t`
JOIN `money_storages` AS `ms`
ON `ms`.`id` = `t`.`source_storage_id` 
    AND `t`.`destination_storage_id` = #{savings_account_storage_id}
    AND `t`.`destination_storage_id` != `t`.`source_storage_id` 
JOIN `types_of_money_storages` AS `ts`
ON `ts`.`id` = `ms`.`type_id` AND `ts`.`type_name` = 'savings_account'
JOIN `savings_accounts` AS `sa`
ON `ms`.`id` = `sa`.`storage_id`
JOIN `users` AS `u`
ON `sa`.`user_id` = `u`.`id`;

#Consultar envíos desde la cuenta de ahorros propia hacia las de otros usuarios.

SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name`, `u`.`email` 
FROM `transactions` AS `t`
JOIN `money_storages` AS `ms`
ON `ms`.`id` = `t`.`destination_storage_id` 
    AND `t`.`source_storage_id` = #{savings_account_storage_id} 
JOIN `types_of_money_storages` AS `ts`
ON `ts`.`id` = `ms`.`type_id` AND `ts`.`type_name` = 'savings_account'
JOIN `savings_accounts` AS `sa`
ON `ms`.`id` = `sa`.`storage_id`
JOIN `users` AS `u`
ON `sa`.`user_id` = `u`.`id`;

#Consultar envíos desde un bolsillo propio hacia las cuentas de ahorros de otros usuarios.

SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name`, `u`.`email`, `p`.`name`
FROM `transactions` AS `t`
JOIN `money_storages` AS `ms1`
ON `ms1`.`id` = `t`.`destination_storage_id` AND `t`.`destination_storage_id` != #{savings_account_storage_id};
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
ON `ms2`.`id`=`p`.`storage_id` AND `p`.`account_id` = #{savings_account_storage_id};

#Consultar recepciones a la cuenta de ahorros propia desde bolsillos de otros usuarios.

SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name`, `u`.`email`, `p`.`name`
FROM `transactions` AS `t`
JOIN `money_storages` AS `ms1`
ON `ms1`.`id` = `t`.`destination_storage_id` AND `t`.`destination_storage_id` = #{savings_account_storage_id}
JOIN `types_of_money_storages` AS `ts1`
ON `ts1`.`id` = `ms1`.`type_id` AND `ts1`.`type_name` = 'savings_account'
JOIN `money_storages` AS `ms2`
ON `ms2`.`id` = `t`.`source_storage_id`
JOIN `types_of_money_storages` AS `ts2`
ON `ts2`.`id` = `ms2`.`type_id` AND `ts2`.`type_name` = 'pocket'
JOIN `pockets` AS `p`
ON `ms2`.`id`=`p`.`storage_id`
JOIN `savings_accounts` AS `sa`
ON `p`.`account_id` = `sa`.`storage_id` AND `p`.`account_id` != #{savings_account_storage_id}
JOIN `users` AS `u`
ON `sa`.`user_id` = `u`.`id`;
