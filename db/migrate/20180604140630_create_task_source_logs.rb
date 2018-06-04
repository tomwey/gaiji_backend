class CreateTaskSourceLogs < ActiveRecord::Migration
  def change
    create_table :task_source_logs do |t|
      t.integer :task_id
      t.string :source
      t.string :extra_data

      t.timestamps null: false
    end
    add_index :task_source_logs, :task_id
  end
end
