require_relative 'DbConnection.rb'

class Users
  def initialize()
    @dbconnection = DbConnection.new()
  end
  def menu
    print "
		Seleccione \n
		1- Registrar Usuario \n
		2- Login"
    $selection = gets
    if $selection.to_i == 1
     return registerUser()
    elsif $selection.to_i == 2
      return loginUser()
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
    puts "Password"
    $passw= gets
    time = Time.new
    results=@dbconnection.query("INSERT INTO `test`.`users` (`name`, `email`, `password`, `registration_timestamp`, `logout`) VALUES ('#{$name}', '#{$email}', '#{$passw}', '#{time}', '1')")
    results=@dbconnection.query("SELECT* FROM users  ORDER BY id DESC LIMIT 1")
    results.each do |row|
      puts  # row["id"].is_a? Integer
      @user_id = row['id']
    end
    puts "RESGITRO EXITOSO"
    return validate(@user_id)
  end
  def loginUser
    puts "Email"
    email= gets.chomp
    email = email.to_s
    puts "Password"
    passw= gets.chomp
    passw= passw.to_s
    results=@dbconnection.query("SELECT * FROM users WHERE users.email = '#{email}'")
    results.each do |row|
      $pass = row['password'].to_s
      $id_user = row['id']
    end
    if (passw == $pass)
      login=1
    else
      login=0
    end
    results=@dbconnection.query("UPDATE `users` SET `logout`='#{login}' WHERE  `id`=#{$id_user}")
    return validate($id_user)
  end
  def validate (user_id_login)
    results=@dbconnection.query("SELECT * FROM users WHERE id = #{user_id_login}")
    results.each do |row|
      @validate_login= row['logout']
      @user_id = row['id']
    end
    if (@validate_login == 1)
      puts ("sesion iniciada");
      return @user_id
    else
      puts ("No tiene sesion iniciada");
      return  0
    end
  end
end



