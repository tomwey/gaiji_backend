class CreateRemainTaskLogs < ActiveRecord::Migration
  def change
    create_table :remain_task_logs do |t|
      t.string :uniq_id
      t.integer :task_id,   null: false
      t.integer :proj_id,   null: false
      t.integer :packet_id, null: false
      t.boolean :in_use, default: false

      t.timestamps null: false
    end
    add_index :remain_task_logs, :uniq_id, unique: true
    add_index :remain_task_logs, :task_id
    add_index :remain_task_logs, :proj_id
    add_index :remain_task_logs, :packet_id
  end
end
