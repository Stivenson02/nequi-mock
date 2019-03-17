class SavingsAccountsAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end

    def look_up_available_money(savings_account_storage_id)
        results = @db_connection.client.query("CALL `look_up_available_money`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a[0][:available_money]
    end

    def look_up_total_money(savings_account_storage_id)
        results = @db_connection.client.query("CALL `look_up_total_money`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a[0][:total_money]
    end

    def deposit_into_savings_account(deposited_money, savings_account_storage_id)
        @db_connection.client.query("CALL `deposit_into_savings_account`(#{deposited_money}, #{savings_account_storage_id});")
        @db_connection.client.abandon_results!
    end

    def withdraw_from_savings_account(withdrawn_money, savings_account_storage_id)
        @db_connection.client.query("CALL `withdraw_from_savings_account`(#{withdrawn_money}, #{savings_account_storage_id});")
        @db_connection.client.abandon_results!
    end

    def send_to_another_user_savings_account(recipient_email, sent_money, savings_account_storage_id)
        @db_connection.client.query("CALL `send_money_from_savings_account_to_another_user_savings_account`('#{recipient_email}', #{sent_money}, #{savings_account_storage_id})")
        @db_connection.client.abandon_results!
    end
    def email_exists(email)
        results = @db_connection.client.query("CALL `email_exists`('#{email}');", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a[0][:exists] == 1 ? (return true) : (return false)
    end
end