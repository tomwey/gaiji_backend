class CreateIdcards < ActiveRecord::Migration
  def change
    create_table :idcards do |t|
      t.string :name
      t.string :card_no, null: false, default: ''

      t.timestamps null: false
    end
    add_index :idcards, :card_no, unique: true
  end
end
