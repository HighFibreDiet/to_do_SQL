require 'pg'

DB = PG.connect(:dbname => 'to_do')

require './lib/task'
require './lib/list'

@current_task
@current_list

def main_menu
	puts "Welcome to your To-Do List Manager!"
	puts "Please choose an option:"
	puts "\tPress 'n' to create a new list"
	puts "\tPress 'v' to view all of your lists"
	puts "\tPress 't' to view all of your tasks"
	puts "\tPress 'x' to exit"

	main_choice = gets.chomp

	case main_choice
	when 'n'
		new_list
		main_menu
	when 'v'
		view_lists
		all_lists_menu
	when 't'
		view_all_tasks
		all_tasks_menu
	when 'x'
		exit
	else
		puts "That input was not valid. Please choose again.\n"
		main_menu
	end
end

def new_list
	puts "Enter a description of your new list"
	new_description = gets.chomp

	new_list = List.new(new_description)
	new_list.save
	puts "\n"
end

def view_lists
	List.all.each_with_index do |list, index|
		puts "#{index + 1}. #{list.name}"
	end
end

def all_lists_menu
	puts "Enter the number of the list you wish to update"
	puts "Enter 'm' to return to the main menu"

	user_input = gets.chomp

	if user_input == 'm'
		main_menu
	elsif (user_input =~ /\D/).nil?
		@current_list = List.all[user_input.to_i - 1]
		list_menu
	else
		puts "That input was invalid. Please try again.\n"
		all_lists_menu
	end

end

def list_menu
	view_list_tasks
	puts "Options for the list '#{@current_list.name}'"
	puts "\tPress 'n' to add a new task"
	puts "\tPress 'd' to delete the whole list"
	puts "\tPress the task number to edit or delete a task"
	puts "\tPress 'm' to return to the main menu"

	list_choice = gets.chomp

	puts "\n"

	if list_choice == 'n'
		new_task
		list_menu
	elsif (list_choice =~ /\D/).nil?
		@current_task = @current_list.tasks[list_choice.to_i - 1]
		task_menu
		list_menu
	elsif list_choice ==  'm'
		main_menu
	elsif list_choice == 'd'
		@current_list.delete
		main_menu
	else
		puts "That was not a valid choice. Please try again.\n"
		list_menu
	end
end

def new_task
	puts "Enter a description of your new task"
	new_description = gets.chomp
	puts "Enter a due date"
	new_due_date = gets.chomp
	new_task = Task.new(new_description, @current_list.id, new_due_date)
	new_task.save
	puts "\n"
end

def view_all_tasks
	puts "Enter 'ASC' to view tasks in ascending order (soonest due listed first): "
	puts "Eneter 'DESC' to view tasks in descending order (furthest away listed first): "

	order_choice = gets.chomp
	puts "Incomplete Tasks:" 
	Task.all(order_choice).each_with_index do |task, index|
		if !task.done?
			puts "#{index + 1}. #{task.name} - Due: #{task.due_date}"
		end
	end
	puts "\nComplete Tasks:"
	Task.all(order_choice).each_with_index do |task, index|
		if task.done?
			puts "#{index + 1}. #{task.name}"
		end
	end
	puts "\n"
end

def all_tasks_menu	
	puts "Enter the number of a task to edit it"
	puts "Press 'm' to return to the main menu"

	task_choice = gets.chomp

	if task_choice == 'm'
		main_menu
	elsif !(task_choice =~ /\d/).nil?
		@current_task = Task.all[task_choice.to_i - 1]
		task_menu
	else
		puts "That input was invalid. Please try again.\n"
		all_tasks_menu
	end
end

def task_menu
	puts "Options for #{@current_task.name}:"
	puts "\tPress 'c' to mark the task complete"
	puts "\tPress 'r' to remove the task"
	puts "\tPress 'd' to change the due date"
	puts "\tPress 'm' to return to the list menu"

	task_choice = gets.chomp

	case task_choice
	when 'c'
		@current_task.mark_done
		main_menu
	when 'r'
		@current_task.delete
		main_menu
	when 'd'
		puts "What would you like the new due date to be (enter a date surrounded by single quotes)?"
		new_due_date = gets.chomp
		@current_task.set_due_date(new_due_date)
		main_menu
	when 'm'
		main_menu
	else
		puts "That was not a valid input. Please choose again"
		task_menu
	end
end

def view_list_tasks
	puts "Incomplete tasks:"
	@current_list.tasks.each_with_index do |task, index|
		if !task.done?
			puts "#{index + 1}. #{task.name} - Due: #{task.due_date}"
		end
	end
	puts "\nComplete tasks:"
	@current_list.tasks.each_with_index do |task, index|
		if task.done?
			puts "#{index + 1}. #{task.name}"
		end
	end
	puts "\n"
end

main_menu