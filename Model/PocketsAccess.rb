class PocketsAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end

    def list_pockets(savings_account_storage_id)
        results = @db_connection.client.query("CALL `list_pockets`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end

    def create_pocket(pocket_name, savings_account_storage_id)
        results = @db_connection.client.query("CALL `create_pocket`('#{pocket_name}', #{savings_account_storage_id});")
        @db_connection.client.abandon_results!
    end

    def delete_pocket(pocket_storage_id)
        results = @db_connection.client.query("CALL `delete_pocket`(#{pocket_storage_id});")
        @db_connection.client.abandon_results!
    end

    def deposit_into_pocket(deposited_money, pocket_storage_id)
        results = @db_connection.client.query("CALL `deposit_into_pocket`(#{deposited_money}, #{pocket_storage_id});")
        @db_connection.client.abandon_results!
    end

    def withdraw_from_pocket(withdrawn_money, pocket_storage_id)
        results = @db_connection.client.query("CALL `withdraw_from_pocket`(#{withdrawn_money}, #{pocket_storage_id});")
        @db_connection.client.abandon_results!
    end

    def send_money_to_another_user_savings_account(recipient_email, sent_money, pocket_storage_id)
        results = @db_connection.client.query("CALL `send_money_from_pocket_to_another_user_savings_account`('#{recipient_email}', #{sent_money}, #{pocket_storage_id});")
        @db_connection.client.abandon_results!
    end
    def email_exists(email)
        results = @db_connection.client.query("CALL `email_exists`('#{email}');", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a[0][:exists] == 1 ? (return true) : (return false)
    end
end