class AddVisibleToNewTaskLogs < ActiveRecord::Migration
  def change
    add_column :new_task_logs, :visible, :boolean, default: true
  end
end
