class GoalsAccess
    def initialize(db_connection)
        @db_connection = db_connection
    end
    def list_goals(savings_account_storage_id)
        results = @db_connection.client.query("CALL `list_goals`(#{savings_account_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end
    def create_goal(goal_name, target_date, target_money, savings_account_storage_id)
        @db_connection.client.query("CALL `create_goal`('#{goal_name}', '#{target_date}', #{target_money}, #{savings_account_storage_id});")
        @db_connection.client.abandon_results!
    end
    def delete_goal(goal_storage_id)
        @db_connection.client.query("CALL `delete_goal`(#{goal_storage_id});")
        @db_connection.client.abandon_results!
    end
    def deposit_into_goal(deposited_money, goal_storage_id)
        @db_connection.client.query("CALL `deposit_into_goal`(#{deposited_money}, #{goal_storage_id});")
        @db_connection.client.abandon_results!
    end
    def validate_date(input_date)
        results = @db_connection.client.query("CALL `validate_date`('#{input_date}')", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a[0][:valid_date]
    end
    def earliest_date
        results = @db_connection.client.query("SELECT CURRENT_DATE + INTERVAL 1 DAY AS `earliest_date`;", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a[0][:earliest_date]
    end
    def max_date
        max_date = '2029-12-31'
        max_date
    end
end