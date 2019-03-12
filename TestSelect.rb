require_relative 'DbConnection.rb'

class TestSelect

  def initialize
    @db_connection = DbConnection.new()
  end

  def select_test
    # results=@db_connection.query("SELECT `name`,`id` FROM `users`
    # WHERE `name` = 'sergio';")

    results = @db_connection.client.query("SELECT `t`.`money_transferred`, `t`.`created_at`, `u`.`name`, `u`.`email`, `p`.`name`
    FROM `transactions` AS `t`
    JOIN `money_storages` AS `ms1`
    ON `ms1`.`id` = `t`.`destination_storage_id` AND `t`.`destination_storage_id` = 1
    JOIN `types_of_money_storages` AS `ts1`
    ON `ts1`.`id` = `ms1`.`type_id` AND `ts1`.`type_name` = 'savings_account'
    JOIN `money_storages` AS `ms2`
    ON `ms2`.`id` = `t`.`source_storage_id`
    JOIN `types_of_money_storages` AS `ts2`
    ON `ts2`.`id` = `ms2`.`type_id` AND `ts2`.`type_name` = 'pocket'
    JOIN `pockets` AS `p`
    ON `ms2`.`id`=`p`.`storage_id`
    JOIN `savings_accounts` AS `sa`
    ON `p`.`account_id` = `sa`.`storage_id` AND `p`.`account_id` != 1
    JOIN `users` AS `u`
    ON `sa`.`user_id` = `u`.`id`;", :symbolize_keys => true)
    puts results.class
    results.each do |row|
      puts row # row["id"].is_a? Integer
    end

    headers = results.fields
    puts headers.class
    puts headers[0]
  end

  def insert_test
    @db_connection.query("INSERT INTO users(name, email, password) VALUES('NombrePrueba', 'Email@prueba.com', 'contra');")
  end
end

#init
object = TestSelect.new()
object.select_test
