require 'mysql2'

class DbConnection

  attr_reader :client

  def initialize
    @client = Mysql2::Client.new(
        host:'127.0.0.1',
        username:'root',
        password:'test',
        port:'33060',
        database:'nequi_mock',
        :flags => Mysql2::Client::MULTI_STATEMENTS
    )
  end
  def query(test)
    results = @client.query(test)
    return  results
  end
end
