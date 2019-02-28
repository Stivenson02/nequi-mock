# Guardaremos toda nuestra configuración en forma de un hash en una variable en ruby
db_config = {
    host: 'localhost',
    adapter: 'postgresql',
    encoding: 'utf-8',
    database: 'postgres',
    schema_search_path: 'public'
}
db_config = db_config.merge({username: 'postgres', password: '123456'})

to_query

$resutad=(db_config)
# Primero llamamos a las gemas de postgres y active_record
# En ruby, para llamar a una gema usamos la palabra require
require 'pg'
require 'active_record'
# Ahora sí utilizamos nuestra conexión
ActiveRecord::Base.establish_connection(db_config)
