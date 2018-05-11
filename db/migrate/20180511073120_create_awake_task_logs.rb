class CreateAwakeTaskLogs < ActiveRecord::Migration
  def change
    create_table :awake_task_logs do |t|
      t.string :uniq_id
      t.integer :task_id,   null: false
      t.integer :proj_id,   null: false
      t.integer :packet_id

      t.timestamps null: false
    end
    add_index :awake_task_logs, :uniq_id, unique: true
    add_index :awake_task_logs, :task_id
    add_index :awake_task_logs, :proj_id
    add_index :awake_task_logs, :packet_id
  end
end
