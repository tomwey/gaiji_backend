class AddTaskTypeToNewTasks < ActiveRecord::Migration
  def change
    add_column :new_tasks, :task_type, :integer, default: 0
    add_index :new_tasks, :task_type
  end
end
