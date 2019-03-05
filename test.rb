require_relative 'mysql2.rb'

class TestSelect
  def initialize()
    @dbconnection = DBConnection.new()
  end
  def selectTest
    results=@dbconnection.query("SELECT* FROM jobs");
    results.each do |row|
      puts row["JOB_ID"] # row["id"].is_a? Integer
    end
  end
end

#init
object = TestSelect.new()
object.selectTest


