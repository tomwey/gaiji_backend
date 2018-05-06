class AddOpenedToRemainTasks < ActiveRecord::Migration
  def change
    add_column :remain_tasks, :opened, :boolean, default: true
  end
end
