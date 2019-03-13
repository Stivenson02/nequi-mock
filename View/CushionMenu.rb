class CushionMenu
    def cushion_menu()
        puts "Menú del colchón"
        puts "1. Consultar el dinero guardado en el colchón"
        puts "2. Depositar dinero en el colchón"
        puts "3. Retirar dinero del colchón"
        puts "4. Regresar al menú anterior"
        print "Selecciona una opción: "
        option = gets()
        option
    end
    def look_up_cushion_money(cushion_money)
        puts "El dinero guardado en tu colchón es: #{cushion_money}"
    end
    def deposit_money_into_cushion
        puts "Ingresa la cantidad de dinero que deseas depositar en el colchón: "
        deposited_money = gets()
        deposited_money
    end
    def withdraw_money_from_cushion
        puts "Ingresa la cantidad de dinero que deseas retirar de tu colchón: "
        withdrawn_money = gets()
        withdrawn_money
    end
end