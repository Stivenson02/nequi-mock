class GoalsMenu
    def goals_menu()
        puts "Menú de las metas"
        puts "1. Listar información de todas las metas"
        puts "2. Crear una nueva meta"
        puts "3. Eliminar una meta"
        puts "4. Agregar dinero a una meta"
        puts "5. Regresar al menú anterior"
    end
    def list_goals(goals_array)
        puts "Lista de todas las metas"
        goals_array.each_with_index{
            |goal, index|
            name = goal[:name]
            target_money = goal[:target_money]
            saved_money = goal[:saved_money]
            remaining_money = goal[:remaining_money]
            was_achieved = nil
            if goal[:was_achieved] == 1
                was_achieved = 'Sí'
            else
                was_achieved = 'No'
            end
            expired = nil
            if goal[:expired] == 1
                expired = 'Sí'
            else
                expired = 'No'
            end
            target_date = goal[:target_date]
            puts "#{index+1}. Nombre: '#{name}', Dinero objetivo: #{target_money}, Dinero ahorrado: #{saved_money}, Dinero faltante: #{remaining_money},
            ¿Fue lograda? #{was_achieved}, Vencida? #{expired}, Fecha objetivo: #{target_date}"
        }
        puts ""
    end
    def create_goal(earliest_date, max_date)
        puts "Ingresa el nombre para la nueva meta: "
        name = text_input()
        puts "Ingresa el objetivo de dinero: "
        target_money = money_input()
        puts "Ingresa la fecha objetivo. Esta debe tener el formato AAAA-MM-DD"
        puts "y debe estar entre el día de mañana (#{earliest_date}) y la fecha #{max_date}"
        target_date = text_input()
        [name, target_money, target_date]
    end
    def delete_goal(goals_array)
        list_goals(goals_array)
        puts "Selecciona el índice de la meta que quieres eliminar: "
        index = goals_index_input(goals_array)
        index
    end
    def deposit_into_goal(goals_array)
        list_goals(goals_array)
        puts "Ingresa el índice de la meta en la que quieres depositar: "
        index = goals_index_input(goals_array)
        puts "Ingresa la cantidad de dinero que quieres depositar: "
        deposited_money = money_input()
        [index, deposited_money]
    end

    #Helper methods

    def goals_index_input(goals_array)
        index = Integer(gets) rescue false
        puts ""
        if index == false
            print "ERROR: Ingresa un índice válido"
            STDIN.getch
            print "\n\n"
            puts "Ingresa nuevamente el índice:"
            return goals_index_input(goals_array)
        elsif index > goals_array.length || index < 1
            print "ERROR: Ingresa un índice válido"
            STDIN.getch
            print "\n\n"
            puts "Ingresa nuevamente el índice:"
            return goals_index_input(goals_array)
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
        elsif option <=5 && option >=1
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
        print "No tienes ninguna meta en este momento"
        STDIN.getch
        print "\n\n"
    end
    def excessive_depositing_error
        print "Error: La cantidad de dinero que quieres depositar no puede ser mayor que la cantidad disponible en la cuenta de ahorros"
        STDIN.getch
        print "\n\n"
    end
    def date_out_of_range_error(earliest_date, max_date)
        print "Error: La fecha objetivo debe estar entre el día de mañana (#{earliest_date}) y la fecha #{max_date}"
        STDIN.getch
        print "\n\n"
    end
    def invalid_date_error
        print "Error: Ingresaste una fecha con el formato inválido o por fuera del rango permitido"
        STDIN.getch
        print "\n\n"
    end
end