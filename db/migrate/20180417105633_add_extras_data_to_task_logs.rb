class AddExtrasDataToTaskLogs < ActiveRecord::Migration
  def change
    add_column :task_logs, :extras_data, :string
  end
end
