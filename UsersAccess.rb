require_relative 'DbConnection.rb'

class UsersAccess
    def initialize(db_connection)
        @db_connection = db_connection
    end

    def user_login(email, password)
        result = @db_connection.client.query("SELECT `id` FROM  `users` WHERE `email` = '#{email}' AND `password` = '#{password}';", :symbolize_keys => true)
        result
    end
end

db_connection = DbConnection.new()
users_access = UsersAccess.new(db_connection)
#results = users_access.user_login('sergioal@gmail.com','1234bb')
results = users_access.user_login('stiven@hotmail.com','galaxia')
key = results.fields[0]
idHash = nil
results.each do |row|
    idHash = row
end
id = idHash[key]
puts id