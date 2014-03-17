require 'pg'

class List
	attr_reader :name, :id
	def initialize(name, id = nil)
		@name = name
		@id = id
	end

	def ==(other_list)
		self.name == other_list.name
	  self.id == other_list.id
	end

	def self.all
		results = DB.exec("SELECT * FROM LISTS;")
		lists = []
		results.each do |result|
			name = result['name']
			id = result['id'].to_i
			lists << List.new(name, id)
		end
		lists
	end

	def save
		results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
		@id = results.first['id'].to_i
	end

	def delete
		DB.exec("DELETE FROM lists WHERE id = '#{@id}'")
		DB.exec("DELETE FROM tasks WHERE list_id = '#{@id}'")
	end

	def tasks
		results = DB.exec("SELECT * FROM tasks WHERE list_id = #{self.id} ORDER BY due_date")
		tasks = []
		results.each do |result|
			name = result['name']
			list_id = result['list_id'].to_i
			due_date = result['due_date']
			status = result['status'] == 't' ? true : false
			tasks << Task.new(name, list_id, due_date, status)
		end
		tasks
	end
end