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


class Controller 
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
        option = Integer(@login_menu.login_menu())
        if option == 1
            login()
        elsif option == 2
            user_registration()
        else
            puts "Error: Ingrese una opción válida"
        end
    end

    def login
        email, password = @login_menu.login()
        ids = @users_access.login(email, password)
        if ids.length == 1
            @user_name = ids[0][:name]
            @user_id = ids[0][:user_id]
            @savings_account_storage_id = ids[0][:savings_account_storage_id]
            @cushion_storage_id = ids[0][:cushion_storage_id]
            main_menu()
        else
            puts "Credenciales incorrectas. Inténtelo de nuevo"
            login_menu()
        end
    end

    def user_registration
        name, email, password = @login_menu.user_registration()
        @users_access.user_registration(name, email, password)
    end

    def main_menu
        option = Integer(@main_menu.main_menu(@user_name))
        if option == 1
            look_up_available_money()
            gets()
            main_menu()
        elsif option == 2
            look_up_total_money()
            gets()
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
            gets()
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
            #Salir del programa
        else
            puts "Error: Ingrese una opción válida"
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
        deposited_money = @main_menu.deposit_into_savings_account
        @savings_accounts_access.deposit_into_savings_account(deposited_money, @savings_account_storage_id)
    end

    def withdraw_from_savings_account
        withdrawn_money = @main_menu.withdraw_from_savings_account
        @savings_accounts_access.withdraw_from_savings_account(withdrawn_money, @savings_account_storage_id)
    end

    def send_from_savings_account_to_another_user_savings_account
        recipient_email, sent_money = @main_menu.send_from_savings_account_to_another_user_savings_account
        @savings_accounts_access.send_to_another_user_savings_account(recipient_email, sent_money, @savings_account_storage_id)
    end

    def transactions_history()
        transaction_history = @transactions_history_access.personal_deposits_into_savings_account(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_personal_deposits_into_sa(transaction_history)
        end

        transaction_history = @transactions_history_access.deposits_into_sa_from_another_sa(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_into_sa_from_another_sa(transaction_history)
        end

        transaction_history = @transactions_history_access.deposits_into_sa_from_another_user_pockets(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_into_sa_from_another_user_pockets(transaction_history)
        end

        transaction_history = @transactions_history_access.personal_withdrawals_from_savings_account(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_personal_withdrawals_from_sa(transaction_history)
        end

        transaction_history = @transactions_history_access.deposits_from_sa_into_another_sa(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_from_sa_into_another_user_sa(transaction_history)
        end

        transaction_history = @transactions_history_access.deposits_from_pockets_into_another_sa(@savings_account_storage_id)
        if transaction_history.length > 0
            @main_menu.history_of_deposits_from_pockets_into_another_user_sa(transaction_history)
        end
    end


    def cushion_menu
        option = Integer(@cushion_menu.cushion_menu)
        if option == 1
            look_up_cushion_money()
            gets()
            cushion_menu()
        elsif option == 2
            deposit_money_into_cushion()
            cushion_menu()
        elsif option == 3
            withdraw_money_from_cushion()
            cushion_menu()
        elsif option == 4
            main_menu()
        else
            puts "Error: Ingrese una opción válida"
        end
    end
    def look_up_cushion_money
        cushion_money = @cushions_access.look_up_cushion_money(@cushion_storage_id)
        @cushion_menu.look_up_cushion_money(cushion_money)
    end
    def deposit_money_into_cushion
        deposited_money = @cushion_menu.deposit_money_into_cushion()
        @cushions_access.deposit_into_cushion(deposited_money, @cushion_storage_id)
    end
    def withdraw_money_from_cushion
        withdrawn_money = @cushion_menu.withdraw_money_from_cushion()
        @cushions_access.withdraw_from_cushion(withdrawn_money, @cushion_storage_id)
    end


    def pockets_menu
        option = Integer(@pockets_menu.pockets_menu)
        if option == 1
            list_pockets()
            gets()
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
        else
            puts "Error: Ingrese una opción válida"
        end
    end

    def list_pockets
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        @pockets_menu.list_pockets(pockets_array)
    end

    def create_pocket
        pocket_name = @pockets_menu.create_pocket
        @pockets_access.create_pocket(pocket_name, @savings_account_storage_id)
    end

    def delete_pocket
        list_pockets()
        index = Integer(@pockets_menu.delete_pocket)
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if index <= pockets_array.length
            pocket_storage_id = pockets_array[index-1][:storage_id]
            @pockets_access.delete_pocket(pocket_storage_id)
        else
            puts "Error: Ingrese una opción válida"
        end
    end

    def deposit_into_pocket
        list_pockets()
        index, deposited_money = @pockets_menu.deposit_into_pocket()
        index = Integer(index)
        deposited_money = Integer(deposited_money)
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if index <= pockets_array.length
            pocket_storage_id = pockets_array[index-1][:storage_id]
            @pockets_access.deposit_into_pocket(deposited_money, pocket_storage_id)
        else
            puts "Error: Ingrese una opción válida"
        end
    end

    def withdraw_from_pocket
        list_pockets()
        index, withdrawn_money = @pockets_menu.withdraw_from_pocket()
        index = Integer(index)
        withdrawn_money = Integer(withdrawn_money)
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if index <= pockets_array.length
            pocket_storage_id = pockets_array[index-1][:storage_id]
            @pockets_access.withdraw_from_pocket(withdrawn_money, pocket_storage_id)
        else
            puts "Error: Ingrese una opción válida"
        end
    end

    def send_money_from_pocket_to_another_user_savings_account
        list_pockets()
        index, recipient_email, sent_money = @pockets_menu.send_money_from_pocket_to_another_user_savings_account()
        index = Integer(index)
        pockets_array = @pockets_access.list_pockets(@savings_account_storage_id)
        if index <= pockets_array.length
            pocket_storage_id = pockets_array[index-1][:storage_id]
            @pockets_access.send_money_to_another_user_savings_account(recipient_email, sent_money, pocket_storage_id)
        else
            puts "Error: Ingrese una opción válida"
        end
    end
end

controller = Controller.new()
controller.login_menu()
