class PocketsAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end

    def list_pockets(savings_account_storage_id)
        results = @db_connection.client.query("CALL `list_pockets`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end

    def create_pocket(pocket_name, savings_account_storage_id)
        results = @db_connection.client.query("CALL `create_pocket`('#{pocket_name}', #{savings_account_storage_id});")
    end

    def delete_pocket(pocket_storage_id)
        results = @db_connection.client.query("CALL `delete_pocket`(#{pocket_storage_id});")
    end

    def deposit_into_pocket(deposited_money, pocket_storage_id)
        results = @db_connection.client.query("CALL `deposit_into_pocket`(#{deposited_money}, #{pocket_storage_id});")
    end

    def withdraw_from_pocket(withdrawn_money, pocket_storage_id)
        results = @db_connection.client.query("CALL `withdraw_from_pocket`(#{withdrawn_money}, #{pocket_storage_id});")
    end

    def send_money_to_another_user_savings_account(recipient_email, sent_money, pocket_storage_id)
        results = @db_connection.client.query("CALL `send_money_from_pocket_to_another_user_savings_account`('#{recipient_email}', #{sent_money}, #{pocket_storage_id});")
    end
end

#tests

# db_connection = DbConnection.new()
# pockets_access = PocketsAccess.new(db_connection)

# pockets_access.create_pocket('Karts', 1)
# db_connection.client.abandon_results!

# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# pocket_storage_id = bolsillos[0][:storage_id]
# puts bolsillos

# pockets_access.deposit_into_pocket(200000, pocket_storage_id)
# db_connection.client.abandon_results!
# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# puts bolsillos

# pockets_access.withdraw_from_pocket(190000, pocket_storage_id)
# db_connection.client.abandon_results!
# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# puts bolsillos

# pockets_access.send_money_to_another_user_savings_account('stiven@gmail.com', 5000, pocket_storage_id)
# db_connection.client.abandon_results!
# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# puts bolsillos

# pockets_access.delete_pocket(pocket_storage_id)
# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# puts bolsillos


# pockets_access.create_pocket('Cine', 1)
# db_connection.client.abandon_results!

# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# pocket_storage_id = bolsillos[0][:storage_id]
# puts bolsillos

# pockets_access.deposit_into_pocket(80000, pocket_storage_id)
# db_connection.client.abandon_results!
# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# puts bolsillos


# pockets_access.create_pocket('Transporte', 3)
# db_connection.client.abandon_results!

# bolsillos = pockets_access.list_pockets(3)
# db_connection.client.abandon_results!
# pocket_storage_id = bolsillos[0][:storage_id]
# puts bolsillos

# pockets_access.deposit_into_pocket(40000, pocket_storage_id)
# db_connection.client.abandon_results!
# bolsillos = pockets_access.list_pockets(1)
# db_connection.client.abandon_results!
# puts bolsillos
