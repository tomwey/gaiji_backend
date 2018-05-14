class AddExtraDataToRemainTaskLogs < ActiveRecord::Migration
  def change
    add_column :remain_task_logs, :extra_data, :string
  end
end
