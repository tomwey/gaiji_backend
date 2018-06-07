class AddVisibleToTaskSourceLogs < ActiveRecord::Migration
  def change
    add_column :task_source_logs, :visible, :boolean, default: true
  end
end
