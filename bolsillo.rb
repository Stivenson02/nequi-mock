require_relative 'DbConnection.rb'

class Bolsillo
  def initialize()
    @dbconnection = DbConnection.new()
  end
  def menu(user_id, account_id  )
    @user_id=user_id
    @account_id=account_id
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
    results=@dbconnection.query(" SELECT * FROM pockets WHERE pockets.account_id = #{@account_id}")
    results.each do |row|
      $data= row
      print "bolsillo "
      puts  row['name']
      print "Dinero "
      puts  row['saved_money']
      puts "_____"
    end
    return $data
  end
  def nuevoPago()
    print "Nombre"
    name = gets.chomp
    name = name.to_s
    print "Valor"
    valor= gets.chomp
    valor=valor.to_i

    time = Time.new

    results=@dbconnection.query("INSERT INTO `test`.`money_storages` (`type_id`) VALUES ('3')")
    results=@dbconnection.query("SELECT* FROM money_storages  ORDER BY id DESC LIMIT 1")
    results.each do |row|
      puts  # row["id"].is_a? Integer
      @tipe_id = row['id']
    end

    results=@dbconnection.query("INSERT INTO `test`.`pockets` (`storage_id`, `account_id`, `name`, `saved_money`, `created_at`, `deleted_at`) VALUES ('#{@tipe_id}', '#{@account_id}', '#{name}', '#{valor}', '#{time}', '#{time}')")
    return 1
  end
  def validate (user_id_login)

  end
end



