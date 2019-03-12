require_relative 'user.rb'
require_relative 'bolsillo.rb'
require_relative 'metas.rb'
require_relative 'cuenta.rb'

class Menu
  def initialize()
    @classUser = Users.new()
    @classBolsillo = Bolsillo.new()
    @classMetas = Metas.new()
    @classCuenta = Cuenta.new()
    @user_id = 0
  end
  def menu
    if (@user_id != 0)
      print "
		Seleccione \n
		1- Cuenta  \n
		2- Transaccion \n
		3- Colchon \n
		4- Bolsillo \n
		5- Metas"
      $selection = gets
      if $selection.to_i == 1
        Cuenta()
      elsif $selection.to_i == 2
        Transaccion()
      elsif $selection.to_i == 3
        Colchon()
      elsif $selection.to_i == 4
        Bolsillo()
      elsif $selection.to_i == 5
        Metas()
      else
        puts "ERROR SELECCIONE UN CAMPO VALIDO"
        menu()
      end
    else
      @user_id =  @classUser.menu()
    end
    menu()
  end
  def Cuenta()
    @classCuenta.menu(@user_id)
  end
  def Colchon()
    puts "Bolsillo"
  end
  def Transaccion()
    puts "Bolsillo"
  end
  def Bolsillo()
   $cuenta= @classCuenta.VerCuenta(@user_id)
   puts "CUENTA"
   puts $cuenta
  end
  def Metas()
    @classMetas.menu(@user_id)
  end
end

#init
object = Menu.new()
object.menu
gets()


