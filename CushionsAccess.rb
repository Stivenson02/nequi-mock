class CushionsAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end

    def look_up_cushion_money(cushion_storage_id)
        results = @db_connection.client.query("CALL `look_up_cushion_money`(#{cushion_storage_id});", :symbolize_keys => true)
        hash_array = results.to_a[0][:cushion_money]
    end

    def deposit_into_cushion(deposited_money, cushion_storage_id)
        @db_connection.client.query("CALL `deposit_into_cushion`(#{deposited_money}, #{cushion_storage_id});")
    end

    def withdraw_from_cushion(withdrawn_money,cushion_storage_id)
        @db_connection.client.query("CALL `withdraw_from_cushion`(#{withdrawn_money}, #{cushion_storage_id});")
    end
end

#tests

# db_connection = DbConnection.new()
# cushions_access = CushionsAccess.new(db_connection)

# cushions_access.deposit_into_cushion(500000, 2)
# db_connection.client.abandon_results!

# cushions_access.deposit_into_cushion(100000, 4)
# db_connection.client.abandon_results!

# cushions_access.withdraw_from_cushion(100000, 2)
# db_connection.client.abandon_results!

# cushions_access.withdraw_from_cushion(20000, 4)
# db_connection.client.abandon_results!

# puts cushions_access.look_up_cushion_money(2)
# db_connection.client.abandon_results!

# puts cushions_access.look_up_cushion_money(4)
# db_connection.client.abandon_results!



