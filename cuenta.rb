require_relative 'mysql2.rb'

class Cuenta
  def initialize()
    @dbconnection = DBConnection.new()
  end
  def menu(user_id)
    @user_id=user_id
    print "
		Seleccione \n
		1- ver cuenta \n
		2- Agregar Dinero"
    $selection = gets
    if $selection.to_i == 1
      return VerCuenta()
    elsif $selection.to_i == 2
      return Agregar()
    else
      puts "ERROR SELECCIONE UN CAMPO VALIDO"
      menu()
    end
  end
  def VerCuenta()

    results=@dbconnection.query("SELECT* FROM savings_accounts WHERE user_id = #{@user_id}")
    results.each do |row|
      $total=  row['total_money']
      $available=  row['available_money']
    end
    puts "Total en la cuenta"
    $total
    puts "Total en la disponible"
    $available
  end
  def Agregar()
    print "Valor"
    valor= gets.chomp
    valor=valor.to_i
    $tlid=0
    results=@dbconnection.query("SELECT * FROM savings_accounts WHERE user_id = #{@user_id}")
    results.each do |row|
      puts row
      $total = row['total_money'].to_i
      $available=  row['available_money'].to_i
      $tlid = row['user_id'].to_i
    end
    if ($tlid == 0)
      results=@dbconnection.query("INSERT INTO `test`.`money_storages` (`type_id`) VALUES ('1')")
      results=@dbconnection.query("SELECT* FROM users  ORDER BY id DESC LIMIT 1")
      results.each do |row|
        puts  # row["id"].is_a? Integer
        @tipe_id = row['id']
      end
      results=@dbconnection.query("INSERT INTO `savings_accounts` (`storage_id`, `user_id`, `available_money`, `total_money`) VALUES ('#{@tipe_id}', '#{@user_id}', '#{valor}', '#{valor}')")
    else
      valort = valor + $total
      valora = valor + $available
      results=@dbconnection.query("UPDATE `savings_accounts` SET `total_money`='#{valort}' WHERE  `user_id`=#{$tlid}")
      results=@dbconnection.query("UPDATE `savings_accounts` SET `available_money`='#{valora}' WHERE  `user_id`=#{$tlid}")
    end
    return 1
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



