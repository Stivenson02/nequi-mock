class LoginMenu
    def login_menu
        puts "Bienvenido a Mock Nequi"
        puts "1. Login"
        puts "2. Registrarse"
        puts "3. Salir del programa"
    end
    def option_input
        print "Selecciona una opción: "
        option = Integer(gets) rescue false
        puts ""
        if option == false
            print "ERROR: Debe ingresar un número"
            STDIN.getch
            print "\n\n"
            option_input()
        elsif option%1 == 0 && option <=3 && option >=1
            return option
        else 
            print "ERROR: El número que seleccionó no corresponde a una opción de este menú"
            STDIN.getch
            print "\n\n"
            option_input()
        end
    end
    def name_input
        puts "Ingresa tu nombre: "
        name = gets().delete!("\r\n\\").strip
        if name.length == 0
            print "ERROR: No puedes dejar vacío tu nombre"
            STDIN.getch
            print "\n\n"
            name_input()
        else
            puts ""
            return name
        end
    end
    def email_input
        puts "Ingresa tu email: "
        email = gets().delete!("\r\n\\").strip
        if email.length == 0
            print "ERROR: No puedes dejar vacío tu email"
            STDIN.getch
            print "\n\n"
            email_input()
        else
            puts ""
            return email
        end
    end
    def password_input
        puts "Ingresa tu contraseña: "
        password = gets().delete!("\r\n\\")
        puts ""
        if password.length == 0
            print "ERROR: No puedes dejar vacía tu contraseña"
            STDIN.getch
            print "\n\n"
            password_input()
        elsif password.length < 1
            print "ERROR: Tu contraseña debe tener 1 caracter como mínimo"
            STDIN.getch
            print "\n\n"
            password_input()
        else

            return password
        end
    end

    #Errors methods
    
    def wrong_credentials_error
        print "ERROR: Credenciales incorrectas"
        STDIN.getch
        print "\n\n"
    end
    def duplicated_email_error
        print "ERROR: Ya existe un usuario con el mismo correo"
        STDIN.getch
        print "\n\n"
    end
    def successful_registration_message
        print "Registro exitoso"
        STDIN.getch
        print "\n\n"
    end
end