class ChangeColumnsForTaskLogs < ActiveRecord::Migration
  def change
    remove_index :task_logs, [:project_id, :packet_id]
    
    remove_index :task_logs, :remain_ratios
    remove_column :task_logs, :remain_ratios
    
    add_column :task_logs, :task_type, :string
    add_column :task_logs, :task_id, :integer
    
    add_index :task_logs, :task_id
  end
end
