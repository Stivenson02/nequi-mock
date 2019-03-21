require_relative '../View/LoginMenu.rb'
require_relative '../View/MainMenu.rb'
require_relative '../View/CushionMenu.rb'
require_relative '../View/PocketsMenu.rb'
require_relative '../View/GoalsMenu.rb'

require_relative '../Model/UsersAccess.rb'
require_relative '../Model/SavingsAccountsAccess.rb'
require_relative '../Model/TransactionsHistoryAccess.rb'
require_relative '../Model/CushionsAccess.rb'
require_relative '../Model/PocketsAccess.rb'
require_relative '../Model/GoalsAccess.rb'
require_relative '../Model/DbConnection.rb'

require 'io/console'    


class Presenter 
    def initialize
            db_connection = DbConnection.new
            @users_access = UsersAccess.new(db_connection)
            @savings_accounts_access = SavingsAccountsAccess.new(db_connection)
            @transactions_history_access = TransactionsHistoryAccess.new(db_connection)
            @cushions_access = CushionsAccess.new(db_connection)
            @pockets_access = PocketsAccess.new(db_connection)
            @goals_access = GoalsAccess.new(db_connection)

            @login_menu = LoginMenu.new
            @main_menu = MainMenu.new
            @cushion_menu = CushionMenu.new
            @pockets_menu = PocketsMenu.new
            @goals_menu = GoalsMenu.new
    end

    def login_menu
        @login_menu.login_menu()
        option_input = @login_menu.option_input()
        if option_input == 1
            login()
        elsif option_input == 2
            user_registration()
        elsif option_input == 3
            #End program execution
        end
    end
    def login
        email = @login_menu.email_input()
        password = @login_menu.password_input()
        ids = @users_access.login(email, password)
        if ids.length == 1
            @user_name = ids[0][:name]
            @user_id = ids[0][:user_id]
            @savings_account_storage_id = ids[0][:savings_account_storage_id]
            @cushion_storage_id = ids[0][:cushion_storage_id]
            main_menu()
        else
            @login_menu.wrong_credentials_error()
            login_menu()
        end
    end
    def user_registration
        name = @login_menu.name_input()
        email = @login_menu.email_input()
        password = @login_menu.password_input()
        begin
            @users_access.user_registration(name, email, password)
            @login_menu.successful_registration_message()
        rescue
            @login_menu.duplicated_email_error()
        end
        login_menu()
    end

    def main_menu
        @main_menu.main_menu(@user_name)
        option = @main_menu.option_input()
        if option == 1
            look_up_available_money()
            main_menu()
        elsif option == 2
            look_up_total_money()
            main_menu()
        elsif option == 3
            deposit_into_savings_account()
            main_menu()
        elsif option == 4
            withdraw_from_savings_account()
            main_menu()
        elsif option == 5
            send_from_savings_account_to_another_user_savings_account()
            main_menu()
        elsif option == 6
            transactions_history()
            main_menu()
        elsif option == 7
            cushion_menu()
        elsif option == 8
            pockets_menu()
        elsif option == 9
            goals_menu()
        elsif option == 10
            login_menu()
        elsif option == 11
            #End program execution
        end
    end
    def look_up_available_money
        available_money = @savings_accounts_access.look_up_available_money(@savings_account_storage_id)
        @main_menu.look_up_available_money(available_money)
    end
    def look_up_total_money
        total_money = @savings_accounts_access.look_up_total_money(@savings_account_storage_id)
        @main_menu.look_up_total_money(total_money)
    end
    def deposit_into_savings_account
        deposited_money = @main_menu.deposit_into_savings_account()
        @savings_accounts_access.deposit_into_savings_account(deposited_money, @savings_account_storage_id)
        @main_menu.successful_action_message()
    end
    def withdraw_from_savings_account
        withdrawn_money = @main_menu.withdraw_from_savings_account()
        begin
            @savings_accounts_access.withdraw_from_savings_account(withdrawn_money, @savings_account_storage_id)
            @main_menu.successful_action_message()
        rescue
            @main_menu.excessive_withdrawing_error()
        end
    end
    def send_from_savings_account_to_another_user_savings_account
        recipient_email, sent_money = @main_menu.send_from_savings_account_to_another_user_savings_account
        if @savings_accounts_access.email_exists(recipient_email)
            begin
                @savings_accounts_access.send_to_another_user_savings_account(recipient_email, sent_money, @savings_account_storage_id)
                @main_menu.successful_action_message()
            rescue
                @main_menu.excessive_sending_error()
            end
        else
            @main_menu.email_does_not_exist_error()
        end
    end
    def transactions_history()
        no_transactions = true
        transaction_history = @transactions_history_access.personal_deposits_into_savings_account(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_personal_deposits_into_sa(transaction_history)
            no_transactions = false
        end
        transaction_history = @transactions_history_access.deposits_into_sa_from_another_sa(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_into_sa_from_another_sa(transaction_history)
            no_transactions = false
        end
        transaction_history = @transactions_history_access.deposits_into_sa_from_another_user_pockets(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_into_sa_from_another_user_pockets(transaction_history)
            no_transactions = false
        end
        transaction_history = @transactions_history_access.personal_withdrawals_from_savings_account(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_personal_withdrawals_from_sa(transaction_history)
            no_transactions = false
        end
        transaction_history = @transactions_history_access.deposits_from_sa_into_another_sa(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_from_sa_into_another_user_sa(transaction_history)
            no_transactions = false
        end
        transaction_history = @transactions_history_access.deposits_from_pockets_into_another_sa(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_from_pockets_into_another_user_sa(transaction_history)
            no_transactions = false
        end
        if no_transactions
            @main_menu.no_transactions_error()
        else
            STDIN.getch
        end
    end
    def cushion_menu
        @cushion_menu.cushion_menu()
        option = @cushion_menu.option_input()
        if option == 1
            look_up_cushion_money()
            cushion_menu()
        elsif option == 2
            deposit_money_into_cushion()
            cushion_menu()
        elsif option == 3
            withdraw_money_from_cushion()
            cushion_menu()
        elsif option == 4
            main_menu()
        end
    end
    def look_up_cushion_money
        cushion_money = @cushions_access.look_up_cushion_money(@cushion_storage_id)
        @cushion_menu.look_up_cushion_money(cushion_money)
    end
    def deposit_money_into_cushion
        deposited_money = @cushion_menu.deposit_money_into_cushion()
        begin
            @cushions_access.deposit_into_cushion(deposited_money, @cushion_storage_id)
            @cushion_menu.successful_action_message()
        rescue
            @cushion_menu.excessive_depositing_error()
        end
    end
    def withdraw_money_from_cushion
        withdrawn_money = @cushion_menu.withdraw_money_from_cushion()
        begin
            @cushions_access.withdraw_from_cushion(withdrawn_money, @cushion_storage_id)
            @cushion_menu.successful_action_message()
        rescue
            @cushion_menu.excessive_withdrawing_error()
        end
    end

    def pockets_menu
        @pockets_menu.pockets_menu()
        option = @pockets_menu.option_input()
        if option == 1
            list_pockets()
            pockets_menu()
        elsif option == 2
            create_pocket()
            pockets_menu()
        elsif option == 3
            delete_pocket()
            pockets_menu()
        elsif option == 4
            deposit_into_pocket()
            pockets_menu()
        elsif option == 5
            withdraw_from_pocket()
            pockets_menu()
        elsif option == 6
            send_money_from_pocket_to_another_user_savings_account()
            pockets_menu()
        elsif option == 7
            main_menu()
        end
    end
    def list_pockets
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if pockets_array.any?
            @pockets_menu.list_pockets(pockets_array)
            STDIN.getch
        else
            @pockets_menu.empty_list_error()
        end
    end
    def create_pocket
        pocket_name = @pockets_menu.create_pocket()
        @pockets_access.create_pocket(pocket_name, @savings_account_storage_id)
        @pockets_menu.successful_action_message()
    end
    def delete_pocket
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if pockets_array.any?
            index = @pockets_menu.delete_pocket(pockets_array)
            pocket_storage_id = pockets_array[index-1][:storage_id]
            @pockets_access.delete_pocket(pocket_storage_id)            
        else
            @pockets_menu.empty_list_error()
        end
    end
    def deposit_into_pocket
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if pockets_array.any?
            begin
                index, deposited_money = @pockets_menu.deposit_into_pocket(pockets_array)
                pocket_storage_id = pockets_array[index-1][:storage_id]
                @pockets_access.deposit_into_pocket(deposited_money, pocket_storage_id)  
                @pockets_menu.successful_action_message()   
            rescue
                @pockets_menu.excessive_depositing_error()
            end  
        else
            @pockets_menu.empty_list_error()
        end
    end
    def withdraw_from_pocket
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if pockets_array.any?
            begin
                index, withdrawn_money = @pockets_menu.withdraw_from_pocket(pockets_array)
                pocket_storage_id = pockets_array[index-1][:storage_id]
                @pockets_access.withdraw_from_pocket(withdrawn_money, pocket_storage_id)  
                @pockets_menu.successful_action_message()
            rescue
                @pockets_menu.excessive_withdrawing_error()
            end     
        else
            @pockets_menu.empty_list_error()
        end
    end
    def send_money_from_pocket_to_another_user_savings_account
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if pockets_array.any?
            index, recipient_email, sent_money = @pockets_menu.send_money_from_pocket_to_another_user_savings_account(pockets_array)
            if @pockets_access.email_exists(recipient_email)
                begin
                    pocket_storage_id = pockets_array[index-1][:storage_id]
                    @pockets_access.send_money_to_another_user_savings_account(recipient_email, sent_money, pocket_storage_id)
                    @pockets_menu.successful_action_message()
                rescue
                    @pockets_menu.excessive_sending_error()
                end
            else
                @pockets_menu.email_does_not_exist_error()
            end
        else
            @pockets_menu.empty_list_error()
        end
    end

    def goals_menu
        @goals_menu.goals_menu()
        option = @goals_menu.option_input()
        if option == 1
            list_goals()
            goals_menu()
        elsif option == 2
            create_goal()
            goals_menu()
        elsif option == 3
            delete_goal()
            goals_menu()
        elsif option == 4
            deposit_into_goal()
            goals_menu()
        elsif option == 5
            main_menu()
        end
    end
    def list_goals
        goals_array = @goals_access.list_goals(@savings_account_storage_id)
        if goals_array.any?
            @goals_menu.list_goals(goals_array)
            STDIN.getch
        else
            @goals_menu.empty_list_error()
        end
    end
    def create_goal
        earliest_date = @goals_access.earliest_date()
        max_date = @goals_access.max_date()
        name, target_money, target_date = @goals_menu.create_goal(earliest_date, max_date)
        begin
            if @goals_access.validate_date(target_date) == 1
                @goals_access.create_goal(name, target_date, target_money, @savings_account_storage_id)
                @goals_menu.successful_action_message()
            else
                @goals_menu.date_out_of_range_error(earliest_date, max_date)
            end
        rescue
            @goals_menu.invalid_date_error()
        end
    end
    def delete_goal
        goals_array = @goals_access.list_goals(@savings_account_storage_id)
        if goals_array.any?
            index = @goals_menu.delete_goal(goals_array)
            goal_storage_id = goals_array[index-1][:storage_id]
            @goals_access.delete_goal(goal_storage_id)
            @goals_menu.successful_action_message()
        else
            @goals_menu.empty_list_error()
        end
    end
    def deposit_into_goal
        goals_array = @goals_access.list_goals(@savings_account_storage_id)
        if goals_array.any?
            index, deposited_money = @goals_menu.deposit_into_goal(goals_array)
            goal_storage_id = goals_array[index-1][:storage_id]
            begin
                @goals_access.deposit_into_goal(deposited_money, goal_storage_id)
                @goals_menu.successful_action_message()
            rescue
                @goals_menu.excessive_depositing_error()
            end
        else
            @goals_menu.empty_list_error()
        end
    end
end

presenter = Presenter.new()
presenter.login_menu()
