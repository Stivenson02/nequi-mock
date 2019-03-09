require 'mysql2'

class DBConnection
  def initialize()
    @client = Mysql2::Client.new(
        host:'localhost',
        username:'root',
        password:'test',
        port:'3306',
        database:'taller9'
    )
  end
  def query(test)
    puts test
    results = @client.query(test)
    return  results
  end
end




