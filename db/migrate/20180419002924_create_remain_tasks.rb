class CreateRemainTasks < ActiveRecord::Migration
  def change
    create_table :remain_tasks do |t|
      t.integer :uniq_id
      t.integer :proj_id
      t.integer :ratio, null: false
      t.date :task_date, null: false
      t.integer :need_task_count, default: 0
      t.integer :join_task_count, default: 0

      t.timestamps null: false
    end
    add_index :remain_tasks, :uniq_id, unique: true
    add_index :remain_tasks, :proj_id
  end
end
