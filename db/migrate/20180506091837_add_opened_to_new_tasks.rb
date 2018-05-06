class AddOpenedToNewTasks < ActiveRecord::Migration
  def change
    add_column :new_tasks, :opened, :boolean, default: true
  end
end
