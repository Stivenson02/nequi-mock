require 'mysql2'

class DBConnection
  def initialize()
    @client = Mysql2::Client.new(
        host:'localhost',
        username:'root',
        password:'',
        port:'3306',
        database:'test'
    )
  end
  def query(test)
    results = @client.query(test)
    return  results
  end
end
