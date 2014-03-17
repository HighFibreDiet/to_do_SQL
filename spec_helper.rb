require 'rspec'
require 'task'
require 'pg'
require 'list'

DB = PG.connect(:dbname => 'to_do_test')

RSpec.configure do |config|
	config.after(:each) do
		DB.exec("DELETE FROM tasks *;")
		DB.exec("DELETE FROM lists *;")
	end
end