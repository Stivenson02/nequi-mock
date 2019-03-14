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
        print "Selecciona una opción: "
        option = gets()
        puts ""
        option
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
        puts "Ingresa el nombre para el nuevo bolsillo: "
        name = gets().delete!("\r\n\\")
        puts ""
        name
    end
    def delete_pocket
        puts "Selecciona el índice del bolsillo que quieres eliminar: "
        index = gets().delete!("\r\n\\")
        puts ""
        index
    end
    def deposit_into_pocket
        puts "Ingresa el índice del bolsillo en el que quieres depositar: "
        index = gets().delete!("\r\n\\")
        puts "Ingresa la cantidad de dinero que quieres depositar: "
        deposited_money = gets().delete!("\r\n\\")
        puts ""
        [index, deposited_money]
    end
    def withdraw_from_pocket
        puts "Ingresa el índice del bolsillo del que quieres retirar dinero: "
        index = gets().delete!("\r\n\\")
        puts "Ingresa la cantidad de dinero que quieres retirar: "
        withdrawn_money = gets().delete!("\r\n\\")
        puts ""
        [index, withdrawn_money]
    end
    def send_money_from_pocket_to_another_user_savings_account
        puts "Ingresa el índice del bolsillo del que quieres enviar el dinero: "
        index = gets().delete!("\r\n\\")
        puts "Ingresa el email del destinatario: "
        email = gets().delete!("\r\n\\")
        puts "Ingresa la cantidad de dinero que deseas enviar al destinatario: "
        sent_money = gets().delete!("\r\n\\")
        puts ""
        [index, email, sent_money]
    end
end