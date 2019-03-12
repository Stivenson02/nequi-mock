CREATE TABLE `users` (
    `id` INTEGER AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL,
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

#A continuación se agregan las entradas necesarias en la tabla types_of_money_storages
#para identificar los pockets, goals, cushions y savings_accounts

INSERT INTO `types_of_money_storages`
VALUES  (1,'savings_account'),
        (2, 'cushion'),
        (3, 'pocket'),
        (4,'goal');
