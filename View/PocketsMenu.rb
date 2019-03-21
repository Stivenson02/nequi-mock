class PocketsMenu
    def pockets_menu()
        puts "Menú de los bolsillos"
        puts "1. Listar información de todos los bolsillos"
        puts "2. Crear un bolsillo nuevo"
        puts "3. Eliminar un bolsillo"
        puts "4. Agregar dinero a un bolsillo"
        puts "5. Retirar dinero de un bolsillo"
        puts "6. Enviar dinero de un bolsillo a otro usuario a través de su email"
        puts "7. Regresar al menú anterior"
    end
    def list_pockets(pockets_array)
        puts "Lista de todos los bolsillos"
        pockets_array.each_with_index{
            |pocket, index|
            name = pocket[:name]
            saved_money = pocket[:saved_money]
            puts "#{index+1}. Nombre del bolsillo: '#{name}', Dinero guardado: #{saved_money}"
        }
        puts ""
    end
    def create_pocket
        puts "Ingresa el nombre del nuevo bolsillo: "
        name = text_input()
        name
    end
    def delete_pocket(pockets_array)
        list_pockets(pockets_array)
        puts "Selecciona el índice del bolsillo que quieres eliminar: "
        index = pocket_index_input(pockets_array)
        index
    end
    def deposit_into_pocket(pockets_array)
        list_pockets(pockets_array)
        puts "Ingresa el índice del bolsillo en el que quieres depositar: "
        index = pocket_index_input(pockets_array)
        puts "Ingresa la cantidad de dinero que quieres depositar: "
        deposited_money = money_input()
        [index, deposited_money]
    end
    def withdraw_from_pocket(pockets_array)
        list_pockets(pockets_array)
        puts "Ingresa el índice del bolsillo del que quieres retirar dinero: "
        index = pocket_index_input(pockets_array)
        puts "Ingresa la cantidad de dinero que quieres retirar: "
        withdrawn_money = money_input()
        [index, withdrawn_money]
    end
    def send_money_from_pocket_to_another_user_savings_account(pockets_array)
        list_pockets(pockets_array)
        puts "Ingresa el índice del bolsillo del que quieres enviar el dinero: "
        index = pocket_index_input(pockets_array)
        puts "Ingresa el email del destinatario: "
        email = text_input()
        puts "Ingresa la cantidad de dinero que deseas enviar al destinatario: "
        sent_money = money_input()
        [index, email, sent_money]
    end

    #Helper methods

    def pocket_index_input(pockets_array)
        index = Integer(gets) rescue false
        puts ""
        if index == false
            print "ERROR: Ingresa un índice válido"
            STDIN.getch
            print "\n\n"
            puts "Ingresa nuevamente el índice:"
            return pocket_index_input(pockets_array)
        elsif index > pockets_array.length || index < 1
            print "ERROR: Ingresa un índice válido"
            STDIN.getch
            print "\n\n"
            puts "Ingresa nuevamente el índice:"
            return pocket_index_input(pockets_array)
        else
            return index
        end
    end
    def option_input
        print "Selecciona una opción: "
        option = Integer(gets) rescue false
        puts ""
        if option == false
            print "ERROR: Debes ingresar un número entero"
            STDIN.getch
            print "\n\n"
            return option_input()
        elsif option <=7 && option >=1
            return option
        else 
            print "ERROR: El número que seleccionaste no corresponde a una opción de este menú"
            STDIN.getch
            print "\n\n"
            return option_input()
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
    def text_input
        text = gets().delete!("\r\n\\").strip
        puts ""
        if text.length == 0
            print "ERROR: No puedes dejar el texto vacío"
            STDIN.getch
            print "\n\n"
            puts "Vuelve a ingresar el texto:"
            text_input()
        else
            return text
        end
    end
    def successful_action_message
        print "Acción exitosa"
        STDIN.getch
        print "\n\n"
    end

    #Errors methods

    def empty_list_error
        print "No tienes ningún bolsillo en este momento"
        STDIN.getch
        print "\n\n"
    end
    def excessive_depositing_error
        print "Error: La cantidad de dinero que quieres depositar no puede ser mayor que la cantidad disponible en la cuenta de ahorros"
        STDIN.getch
        print "\n\n"
    end
    def excessive_withdrawing_error
        print "Error: La cantidad de dinero que quieres retirar no puede ser mayor que la cantidad disponible en tu bolsillo."
        STDIN.getch
        print "\n\n"
    end
    def excessive_sending_error
        print "Error: La cantidad de dinero que quieres enviar no puede ser mayor que la cantidad almacenada en tu bolsillo."
        STDIN.getch
        print "\n\n"
    end
    def email_does_not_exist_error
        print "Error: No existe un usuario con el correo indicado"
        STDIN.getch
        print "\n\n"
    end
end