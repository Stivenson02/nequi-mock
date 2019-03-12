require_relative 'mysql2.rb'

class Bolsillo
  def initialize()
    @dbconnection = DBConnection.new()
  end
  def menu(user_id)
    @user_id=user_id
    print "
		Seleccione \n
		1- Ver Bolsillo \n
		2- Nuevo Pago"
    $selection = gets
    if $selection.to_i == 1
      return verBolsillo()
    elsif $selection.to_i == 2
      return nuevoPago()
    else
      puts "ERROR SELECCIONE UN CAMPO VALIDO"
      menu()
    end
  end
  def verBolsillo()

  end
  def nuevoPago()

  end
  def validate (user_id_login)

  end
end



