require_relative 'DbConnection.rb'
class UsersAccess
    def initialize(db_connection)
        @db_connection = db_connection
    end

    def login(email, password)
        results = @db_connection.client.query("CALL `login`('#{email}', '#{password}');", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        results.to_a
    end

    def user_registration(name, email, password)
        @db_connection.client.query("CALL `register_user`('#{name}','#{email}','#{password}');")
        @db_connection.client.abandon_results!
    end
end

# tests

#db_connection and class object
db_connection = DbConnection.new()
users_access = UsersAccess.new(db_connection)

# #test user_registration
# users_access.user_registration('stiven','stiven@gmail.com','1234')
# db_connection.client.abandon_results!

#test login
puts users_access.login('stiven@gmail.com', '1234')
db_connection.client.abandon_results!

#db_connection.client.abandon_results!  Se usa para poder llamar varios stored procedures en sucesión rápida
