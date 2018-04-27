class AddCompleteCountToRemainTasks < ActiveRecord::Migration
  def change
    add_column :remain_tasks, :complete_count, :integer, default: 0
  end
end
