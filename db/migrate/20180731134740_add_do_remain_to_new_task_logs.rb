class AddDoRemainToNewTaskLogs < ActiveRecord::Migration
  def change
    add_column :new_task_logs, :do_remain_at, :datetime
  end
end
