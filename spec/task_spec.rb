require './spec_helper.rb'

describe Task do
	it 'is intialized with a name' do
		task = Task.new('learn SQL', 1)
		task.should be_an_instance_of Task
	end

	it 'tells you its name' do
		task = Task.new('learn SQL', 1)
		task.name.should eq 'learn SQL'
	end

	it 'tells you its list ID' do
		task = Task.new('learn SQL', 1)
		task.list_id.should eq 1
	end

	it 'starts with no tasks' do
		Task.all.should eq []
	end

	it 'lets you save tasks to the database' do
		task = Task.new('learn SQL', 1, '2014-3-25')
		task.save
		Task.all.should eq [task]
	end

	it 'is the same task if it has the same name' do
		task1 = Task.new('learn SQL', 1)
		task2 = Task.new('learn SQL', 1)
		task1.should eq task2
	end

	it 'lets you delete a task from the database' do
		task = Task.new('Hug Travis', 1)
		task.save
		task2 = Task.new('Drink plenty of water', 1)
		task2.save
		task.delete
		Task.all.should eq [task2]

	end

	it 'lets you see its status' do
		task = Task.new('Shower', 1)
		task.done?.should eq false
	end

	it 'lets you mark it as done' do
		task = Task.new('Shower', 1)
		task.mark_done
		task.done?.should eq true
	end

	it 'returns tasks with the correct due date from Task.all' do
		task = Task.new('Shower', 1, '2014-3-25')
		task.save
		Task.all.first.due_date.should eq '2014-03-25'
	end
	
end