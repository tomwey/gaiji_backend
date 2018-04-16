class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer  :uniq_id
      t.string   :name,        null: false, default: ''
      t.string   :icon
      t.string   :bundle_id,   null: false, default: ''
      t.integer  :task_count
      t.integer  :complete_count, default: 0
      t.datetime :task_started_at
      t.string   :task_desc
      t.string   :download_urls, array: true, default: []
      t.boolean  :opened, default: true

      t.timestamps null: false
    end
    add_index :projects, :uniq_id, unique: true
    add_index :projects, :bundle_id, unique: true
  end
end
