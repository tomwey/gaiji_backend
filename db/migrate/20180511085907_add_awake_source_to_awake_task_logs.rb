class AddAwakeSourceToAwakeTaskLogs < ActiveRecord::Migration
  def change
    add_column :awake_task_logs, :awake_source, :string
  end
end
