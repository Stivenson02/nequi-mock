class CushionsAccess

    def initialize(db_connection)
        @db_connection = db_connection
    end

    def look_up_cushion_money(cushion_storage_id)
        results = @db_connection.client.query("CALL `look_up_cushion_money`(#{cushion_storage_id});", :symbolize_keys => true)
        @db_connection.client.abandon_results!
        cushion_money = results.to_a[0][:cushion_money]
    end

    def deposit_into_cushion(deposited_money, cushion_storage_id)
        @db_connection.client.query("CALL `deposit_into_cushion`(#{deposited_money}, #{cushion_storage_id});")
        @db_connection.client.abandon_results!
    end

    def withdraw_from_cushion(withdrawn_money,cushion_storage_id)
        @db_connection.client.query("CALL `withdraw_from_cushion`(#{withdrawn_money}, #{cushion_storage_id});")
        @db_connection.client.abandon_results!
    end
end

