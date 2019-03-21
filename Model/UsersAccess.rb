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