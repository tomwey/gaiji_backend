class CreateNewTasks < ActiveRecord::Migration
  def change
    create_table :new_tasks do |t|
      t.integer :uniq_id
      t.integer :proj_id, null: false
      t.integer :task_count, null: false
      t.integer :complete_count, default: 0
      t.date :task_date, null: false

      t.timestamps null: false
    end
    add_index :new_tasks, :uniq_id, unique: true
    add_index :new_tasks, :proj_id
  end
end
