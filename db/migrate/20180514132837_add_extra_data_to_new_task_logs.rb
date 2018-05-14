class AddExtraDataToNewTaskLogs < ActiveRecord::Migration
  def change
    add_column :new_task_logs, :extra_data, :string
  end
end
