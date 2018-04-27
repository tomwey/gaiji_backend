class CreateUserChats < ActiveRecord::Migration
  def change
    create_table :user_chats do |t|
      t.string :content, null: false, default: ''

      t.timestamps null: false
    end
  end
end
