class GoalsMenu
    def pockets_menu()
        puts "Menú de los bolsillos"
        puts "1. Listar información de todas las metas"
        puts "2. Crear una nueva meta"
        puts "3. Eliminar una meta"
        puts "4. Agregar dinero a una meta"
        puts "5. Regresar al menú anterior"
        print "Selecciona una opción: "
        option = gets()
        option
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
            Fue lograda? #{was_achieved}, Vencida? #{expired}, Fecha objetivo: #{target_date}"
        }
    end
    def create_goal
        puts "Ingresa el nombre para la nueva meta: "
        name = gets()
        puts "Ingresa el objetivo de dinero: "
        target_money = gets()
        puts "Ingresa la fecha objetivo: "
        target_date = gets()
        [name, target_money, target_date]
    end
    def delete_goal
        puts "Selecciona el índice de la meta que quieres eliminar: "
        index = gets()
        index
    end
    def deposit_into_goal
        puts "Ingresa el índice de la meta en la que quieres depositar: "
        index = gets()
        puts "Ingresa la cantidad de dinero que quieres depositar: "
        deposited_money = gets()
        [index, deposited_money]
    end
end