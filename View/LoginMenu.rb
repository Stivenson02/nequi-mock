class LoginMenu
    def login_menu
        puts "Bienvenido a Mock Nequi"
        puts "1. Login"
        puts "2. Registrarse"
        print "Selecciona una opción: "
        option = gets()
        option
    end
    def user_registration
        puts "Ingresa tu nombre: "
        name = gets().delete!("\r\n\\")
        puts "Ingresa tu email: "
        email = gets().delete!("\r\n\\")
        puts "Ingresa tu contraseña: "
        password = gets().delete!("\r\n\\")
        [name, email, password]
    end
    def login
        puts "Ingresa tu email: "
        email = gets().delete!("\r\n\\")
        puts "Ingresa tu contraseña: "
        password = gets().delete!("\r\n\\")
        [email, password]
    end
end