require_relative 'mysql2.rb'

class Users
  def initialize()
    @dbconnection = DBConnection.new()
  end
  def menu
    print "
		Seleccione \n
		1- Registrar Usuario \n
		2- Login"
    $selection = gets
    if $selection.to_i == 1
      registerUser()
    elsif $selection.to_i == 2
      loginUser()
    else
      puts "ERROR SELECCIONE UN CAMPO VALIDO"
      menu()
    end
  end
  def registerUser()
    puts "Email"
    $email= gets
    puts "Nombre"
    $name= gets
    puts "Apellido"
    $lastname= gets
    puts "Password"
    $passw= gets
    time1 = Time.new
    results=@dbconnection.query("INSERT INTO `mentoria9`.`users` (`email`, `name`, `last_name`, `password`, `is_active`, `logout`, `created_at`, `updated_at`) VALUES ('#{$email}', '#{$name}', '#{$lastname}', '#{$passw}', '1', '1', '#{time1.inspect}', '#{time1.inspect}')");
    return 1
  end
  def loginUser
    results=@dbconnection.query("SELECT* FROM jobs");
    results.each do |row|
      puts row["JOB_ID"] # row["id"].is_a? Integer
    end
  end
end

#init
object = Users.new()
object.menu
gets()


