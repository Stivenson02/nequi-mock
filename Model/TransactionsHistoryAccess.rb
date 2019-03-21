class TransactionsHistoryAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end
    def personal_deposits_into_savings_account(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_personal_deposits_into_savings_account`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
    def personal_withdrawals_from_savings_account(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_personal_withdrawals_from_savings_account`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
    def deposits_into_sa_from_another_sa(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_into_sa_from_another_sa`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
    def deposits_from_sa_into_another_sa(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_from_sa_into_another_sa`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
    def deposits_from_pockets_into_another_sa(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_from_pockets_into_another_sa`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
    def deposits_into_sa_from_another_user_pockets(savings_account_storage_id)
        results = @db_connection.client.query("CALL `history_of_deposits_into_sa_from_another_user_pockets`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
end