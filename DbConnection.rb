require 'mysql2'

class DbConnection

  attr_reader :client

  def initialize
    @client = Mysql2::Client.new(
        host:'localhost',
        username:'root',
        password:'test',
        port:'3306',
        database:'mentoria9'
    )
  end
  
end




