class CushionMenu
    def cushion_menu()
        puts "Menú del colchón"
        puts "1. Consultar el dinero guardado en el colchón"
        puts "2. Depositar dinero en el colchón"
        puts "3. Retirar dinero del colchón"
        puts "4. Regresar al menú anterior"
    end
    def look_up_cushion_money(cushion_money)
        print "El dinero guardado en tu colchón es: #{cushion_money}"
        STDIN.getch
        print "\n\n"
    end
    def deposit_money_into_cushion
        puts "Ingresa la cantidad de dinero que quieres depositar en el colchón: "
        deposited_money = money_input
        deposited_money
    end
    def withdraw_money_from_cushion
        puts "Ingresa la cantidad de dinero que quieres retirar de tu colchón: "
        withdrawn_money =  money_input
        withdrawn_money
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
        elsif option <=4 && option >=1
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
        print "Error: La cantidad de dinero que desea retirar no puede ser mayor que la cantidad guardada en el colchón"
        STDIN.getch
        print "\n\n"
    end
    def excessive_depositing_error
        print "Error: La cantidad de dinero que desea depositar no puede ser mayor que la cantidad disponible en la cuenta de ahorros"
        STDIN.getch
        print "\n\n"
    end
end