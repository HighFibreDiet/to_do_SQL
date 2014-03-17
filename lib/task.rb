require 'pg'
require 'Date'

class Task
	attr_reader :name, :list_id, :due_date

	def initialize(name, list_id, due_date = '12-31-14',status = false)
		@name = name
		@list_id = list_id
		@status = status
		@due_date = due_date
	end

	def mark_done
		@status = true
		DB.exec("UPDATE tasks SET status = 't' WHERE name = '#{@name}' and list_id = #{list_id}")
	end

	def done?
		@status
	end

	def set_due_date(date)
		@due_date = date
		DB.exec("UPDATE tasks SET due_date = #{date} WHERE name = '#{@name}' and list_id = #{list_id}")
	end

	def self.all(order = 'ASC')
		results = DB.exec("SELECT * FROM tasks ORDER BY due_date #{order};")
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

	def ==(another_task)
		self.name == another_task.name && self.list_id == another_task.list_id
	end

	def save
		DB.exec("INSERT INTO tasks (name, list_id, due_date) VALUES ('#{@name}', '#{@list_id}', '#{@due_date}');")
	end

	def delete
		DB.exec("DELETE FROM tasks WHERE name = '#{@name}' and list_id = '#{@list_id}';")
	end

end