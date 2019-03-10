require_relative 'mysql2.rb'

class TestSelect
  def initialize()
    @dbconnection = DBConnection.new()
  end
  def selectTest
    results=@dbconnection.query("SELECT * FROM users");
    results.each do |row|
      puts row # row["id"].is_a? Integer
    end
  end

  def insertTest
    @dbconnection.query("INSERT INTO users(name, email, password) VALUES('NombrePrueba', 'Email@prueba.com', 'contra');");
  end

end

#init
object = TestSelect.new()
object.selectTest
object.insertTest
