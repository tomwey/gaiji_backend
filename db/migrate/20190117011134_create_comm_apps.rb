class CreateCommApps < ActiveRecord::Migration
  def change
    create_table :comm_apps do |t|
      t.string :name, null: false
      t.string :bundle_id, null: false

      t.timestamps null: false
    end
  end
end
