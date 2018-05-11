class CreateAwakeTasks < ActiveRecord::Migration
  def change
    create_table :awake_tasks do |t|
      t.integer :uniq_id
      t.integer :proj_id, null: false
      t.integer :task_count, null: false
      t.integer :complete_count, default: 0
      t.date :task_date
      t.integer :sort, default: 0
      t.boolean :opened, default: true
      
      t.timestamps null: false
    end
    add_index :awake_tasks, :uniq_id, unique: true
    add_index :awake_tasks, :proj_id
  end
end
