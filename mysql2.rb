require 'mysql2'
require 'json'
client = Mysql2::Client.new(
    host:'localhost',
    username:'root',
    password:'',
    port:'3306',
    database:'mentoria8'

)
results = client.query("SELECT* FROM jobs")

results.each do |row|
  # conveniently, row is a hash
  # the keys are the fields, as you'd expect
  # the values are pre-built ruby primitives mapped from their corresponding field types in MySQL
  puts row["JOB_ID"] # row["id"].is_a? Integer
end