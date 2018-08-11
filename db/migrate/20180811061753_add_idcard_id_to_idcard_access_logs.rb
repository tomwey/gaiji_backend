class AddIdcardIdToIdcardAccessLogs < ActiveRecord::Migration
  def change
    add_column :idcard_access_logs, :idcard_id, :integer
    add_index :idcard_access_logs, :idcard_id
  end
end
