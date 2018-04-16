class CreateTaskLogs < ActiveRecord::Migration
  def change
    create_table :task_logs do |t|
      t.string :uniq_id
      t.integer :project_id, null: false
      t.integer :packet_id,  null: false
      t.integer :remain_ratios, array: true, default: []

      t.timestamps null: false
    end
    add_index :task_logs, :uniq_id, unique: true
    add_index :task_logs, :project_id
    add_index :task_logs, :packet_id
    add_index :task_logs, [:project_id, :packet_id], unique: true
    add_index :task_logs, :remain_ratios, using: 'gin'
  end
end
