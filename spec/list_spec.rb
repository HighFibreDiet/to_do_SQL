require './spec_helper.rb'

describe List do
	it 'is initialized with a name' do
		list = List.new('Epicodus stuff')
		list.should be_an_instance_of List
	end

	it 'tells you its name' do
		list = List.new('Epicodus Stuff')
		list.name.should eq 'Epicodus Stuff'
	end

	it 'is the same list if it has the same name' do
		list1 = List.new('Epicodus stuff')
		list2 = List.new('Epicodus stuff')
		list1.should eq list2
	end

	it 'starts off with no lists' do
		List.all.should eq []
	end

	it 'lets you save lists to the database' do
		list = List.new('learn SQL')
		list.save
		List.all.should eq [list]
	end

	it 'lets you delete lists from the database' do
		list = List.new('chores')
		list2 = List.new('homework')
		list2.save
		list.save
		list.delete
		List.all.should eq [list2]
	end

	it 'also deletes the tasks from a list when you delete it' do
		list = List.new('chores')
		list.save
		task = Task.new('mop the kitchen', list.id)
		task2 = Task.new('learn SQL', list.id + 1)
		task.save
		task2.save
		list.delete
	end

	it 'sets its ID when you save it' do
		list = List.new('learn SQL')
		list.save
		list.id.should be_an_instance_of Fixnum
	end

	it 'can be initialized with its database ID' do
		list = List.new('Epicodus stuff', 1)
		list.should be_an_instance_of List
	end

	it 'will list out all of its tasks' do
		list = List.new('Making dinner')
		list.save
		task1 = Task.new('buy ingredients', list.id)
		task1.save
		task2 = Task.new('pre-heat the oven', list.id)
		task2.save
		list.tasks.should eq [task1, task2]
	end 
end