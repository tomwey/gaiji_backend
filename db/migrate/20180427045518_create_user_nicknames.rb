class CreateUserNicknames < ActiveRecord::Migration
  def change
    create_table :user_nicknames do |t|
      t.string :nickname, null: false, default: ''

      t.timestamps null: false
    end
    add_index :user_nicknames, :nickname, unique: true
  end
end
