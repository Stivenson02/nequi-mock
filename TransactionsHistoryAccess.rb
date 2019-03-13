class TransactionsHistoryAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end
    def personal_deposits_into_savings_account(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_personal_deposits_into_savings_account`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end
    def personal_withdrawals_from_savings_account(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_personal_withdrawals_from_savings_account`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end
    def deposits_into_sa_from_another_sa(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_into_sa_from_another_sa`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end
    def deposits_from_sa_into_another_sa(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_from_sa_into_another_sa`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end
    def deposits_from_pockets_into_another_sa(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_from_pockets_into_another_sa`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end
    def deposits_into_sa_from_another_user_pockets(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_into_sa_from_another_user_pockets`(#{savings_account_storage_id});", :symbolize_keys => true)
        results.to_a
    end
end

#Tests
# db_connection = DbConnection.new()
# transaction_history_access = TransactionsHistoryAccess.new(db_connection)

# id = 1

# puts transaction_history_access.personal_deposits_into_savings_account(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.personal_withdrawals_from_savings_account(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_into_sa_from_another_sa(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_from_sa_into_another_sa(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_into_sa_from_another_user_pockets(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_from_pockets_into_another_sa(id)
# db_connection.client.abandon_results!

# id = 3

# puts transaction_history_access.personal_deposits_into_savings_account(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.personal_withdrawals_from_savings_account(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_into_sa_from_another_sa(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_from_sa_into_another_sa(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_into_sa_from_another_user_pockets(id)
# db_connection.client.abandon_results!
# puts "\n"
# puts transaction_history_access.deposits_from_pockets_into_another_sa(id)
# db_connection.client.abandon_results!
