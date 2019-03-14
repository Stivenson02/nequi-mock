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
        results = @db_connection.client.query("CALL `create_goal`('#{goal_name}', '#{target_date}', #{target_money}, #{savings_account_storage_id});")
        @db_connection.client.abandon_results!
    end

    def delete_goal(goal_storage_id)
        results = @db_connection.client.query("CALL `delete_goal`(#{goal_storage_id});")
        @db_connection.client.abandon_results!
    end

    def deposit_into_goal(deposited_money, goal_storage_id)
        results = @db_connection.client.query("CALL `deposit_into_goal`(#{deposited_money}, #{goal_storage_id});")
        @db_connection.client.abandon_results!
    end
end

#tests

# db_connection = DbConnection.new()
# goals_access = GoalsAccess.new(db_connection)

# goals = goals_access.list_goals(1)
# puts goals
# db_connection.client.abandon_results!

# goals_access.create_goal('Ahorro para hamburguesa', '2017-6-24', 45000, 1)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(1)
# puts goals
# db_connection.client.abandon_results!
# id = goals[0][:storage_id]

# goals_access.deposit_into_goal(20000, id)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(1)
# puts goals
# db_connection.client.abandon_results!

# goals_access.deposit_into_goal(30000, id)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(1)
# puts goals
# db_connection.client.abandon_results!

# goals_access.delete_goal(id)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(1)
# puts goals
# db_connection.client.abandon_results!


# goals_access.create_goal('Ahorro cine', '2019-3-23', 30000, 3)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(3)
# puts goals
# db_connection.client.abandon_results!
# id = goals[0][:storage_id]

# goals_access.deposit_into_goal(20000, id)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(3)
# puts goals
# db_connection.client.abandon_results!

# goals_access.deposit_into_goal(5000, id)
# db_connection.client.abandon_results!

# goals = goals_access.list_goals(3)
# puts goals
# db_connection.client.abandon_results!