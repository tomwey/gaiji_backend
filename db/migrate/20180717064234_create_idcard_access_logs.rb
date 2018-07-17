class CreateIdcardAccessLogs < ActiveRecord::Migration
  def change
    create_table :idcard_access_logs do |t|
      t.integer :proj_id, null: false
      t.string :idcard, null: false

      t.timestamps null: false
    end
    add_index :idcard_access_logs, :proj_id
    add_index :idcard_access_logs, :idcard
  end
end
