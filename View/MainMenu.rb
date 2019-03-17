class MainMenu
    def main_menu(name)
        puts "Bienvenido #{name}"
        puts "Menú principal."
        puts "1. Consultar el saldo disponible en tu cuenta"
        puts "2. Consultar el saldo total en tu cuenta"
        puts "3. Depositar dinero en tu cuenta"
        puts "4. Retirar dinero de tu cuenta"
        puts "5. Enviar dinero a otro usuario a través de su email"
        puts "6. Consultar tus transacciones"
        puts "7. Entrar al menú del colchón"
        puts "8. Entrar al menú de bolsillos"
        puts "9. Entrar al menú de metas"
        puts "10. Cerrar sesión"
        puts "11. Salir del programa"
    end
    def look_up_available_money(available_money)
        print "El saldo disponible en tu cuenta es: #{available_money} "
        STDIN.getch
        print "\n\n"
    end
    def look_up_total_money(total_money)
        print "El saldo total en tu cuenta es: #{total_money} "
        STDIN.getch
        print "\n\n"
    end
    def deposit_into_savings_account
        puts "Ingresa la cantidad de dinero que deseas depositar en tu cuenta de ahorros: "
        deposited_money = money_input
        deposited_money
    end
    def withdraw_from_savings_account
        puts "Ingresa la cantidad de dinero que deseas retirar de tu cuenta de ahorros: "
        withdrawn_money = money_input
        withdrawn_money
    end
    def send_from_savings_account_to_another_user_savings_account
        puts "Ingresa el email del destinatario: "
        email = gets().delete!("\r\n\\")
        puts ""
        puts "Ingresa la cantidad de dinero que deseas enviar al destinatario: "
        sent_money = money_input
        [email, sent_money] 
    end
    def history_of_personal_deposits_into_sa(history_array)
        puts "DEPÓSITOS PERSONALES EN LA CUENTA DE AHORROS"
        history_array.each{
            |transaction|
            deposited_money = transaction[:money_transferred]
            timestamp = transaction[:created_at]
            puts "'#{timestamp}' Depósito de #{deposited_money}"
        }
        puts ""
    end
    def history_of_deposits_into_sa_from_another_sa(history_array)
        puts "DEPÓSITOS EN LA CUENTA DE AHORROS DESDE CUENTAS DE AHORROS DE OTROS USUARIOS"
        history_array.each{
            |transaction|
            deposited_money = transaction[:money_transferred]
            timestamp = transaction[:created_at]
            sender_name = transaction[:sender_name]
            sender_email = transaction[:sender_email]
            puts "'#{timestamp}' Depósito de #{deposited_money} por parte del usuario '#{sender_name}' con email '#{sender_email}'"
        }
        puts ""
    end
    def history_of_deposits_into_sa_from_another_user_pockets(history_array)
        puts "DEPÓSITOS EN LA CUENTA DE AHORROS DESDE BOLSILLOS DE OTROS USUARIOS"
        history_array.each{
            |transaction|
            deposited_money = transaction[:money_transferred]
            timestamp = transaction[:created_at]
            sender_name = transaction[:sender_name]
            sender_email = transaction[:sender_email]
            pocket_name = transaction[:pocket_name]
            puts "'#{timestamp}' Depósito de #{deposited_money} desde el bolsillo '#{pocket_name}' del usuario '#{sender_name}' con email '#{sender_email}'"
        }
        puts ""
    end
    def history_of_personal_withdrawals_from_sa(history_array)
        puts "RETIROS PERSONALES DE LA CUENTA DE AHORROS"
        history_array.each{
            |transaction|
            withdrawn_money = transaction[:money_transferred]
            timestamp = transaction[:created_at]
            puts "'#{timestamp}' Retiro de #{withdrawn_money}"
        }
        puts ""
    end
    def history_of_deposits_from_sa_into_another_user_sa(history_array)
        puts "TRANSFERENCIAS DESDE LA CUENTA DE AHORROS A LAS CUENTAS DE AHORROS DE OTROS USUARIOS"
        history_array.each{
            |transaction|
            deposited_money = transaction[:money_transferred]
            timestamp = transaction[:created_at]
            recipient_name = transaction[:recipient_name]
            recipient_email = transaction[:recipient_email]
            puts "'#{timestamp}' Transferencia de #{deposited_money} al usuario '#{recipient_name}' con email '#{recipient_email}'"
        }
        puts ""
    end
    def history_of_deposits_from_pockets_into_another_user_sa(history_array)
        puts "TRANSFERENCIAS DESDE BOLSILLOS A LAS CUENTAS DE AHORROS DE OTROS USUARIOS"
        history_array.each{
            |transaction|
            deposited_money = transaction[:money_transferred]
            timestamp = transaction[:created_at]
            recipient_name = transaction[:recipient_name]
            recipient_email = transaction[:recipient_email]
            pocket_name = transaction[:pocket_name]
            puts "'#{timestamp}' Depósito de #{deposited_money} desde el bolsillo '#{pocket_name}' al usuario '#{recipient_name}' con email '#{recipient_email}'"
        }
        puts ""
    end

    #Helper methods

    def option_input
        print "Selecciona una opción: "
        option = Integer(gets) rescue false
        puts ""
        if option == false
            print "ERROR: Debes ingresar un número entero"
            STDIN.getch
            print "\n\n"
            option_input()
        elsif option <=11 && option >=1
            return option
        else 
            print "ERROR: El número que seleccionaste no corresponde a una opción de este menú"
            STDIN.getch
            print "\n\n"
            option_input()
        end
    end
    def money_input
        money = Integer(gets) rescue false
        puts ""
        if money == false
            print "ERROR: Debes ingresar un número entero"
            STDIN.getch
            print "\n\n"
            puts "Vuelve a ingresar la cantidad:"
            money_input()
        elsif money <= 0
            print "ERROR: Debes ingresar un cantidad mayor a 0"
            STDIN.getch
            print "\n\n"
            puts "Vuelve a ingresar la cantidad:"
            money_input()
        else
            return money
        end
    end
    def successful_action_message
        print "Acción exitosa"
        STDIN.getch
        print "\n\n"
    end

    #Errors methods

    def excessive_withdrawing_error
        print "Error: La cantidad de dinero que quieres retirar no puede ser mayor que la cantidad disponible en tu cuenta de ahorros."
        STDIN.getch
        print "\n\n"
    end
    def email_does_not_exist_error
        print "Error: No existe un usuario con el correo indicado"
        STDIN.getch
        print "\n\n"
    end
    def excessive_sending_error
        print "Error: La cantidad de dinero que quieres enviar no puede ser mayor que la cantidad disponible en tu cuenta de ahorros."
        STDIN.getch
        print "\n\n"
    end
    def no_transactions_error
        print "No has hecho ninguna transacción hasta el momento"
        STDIN.getch
        print "\n\n"
    end
end