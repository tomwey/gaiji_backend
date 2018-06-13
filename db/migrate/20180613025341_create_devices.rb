class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :uniq_id
      t.string :model
      t.string :hardware
      t.string :density
      t.string :abi
      t.string :resolution
      t.string :product_type
      t.string :product_id
      t.string :memory
      t.string :radio_version
      t.string :dpi
      t.string :abi2
      t.string :tags
      t.string :host
      t.string :display
      t.string :board
      t.string :product
      t.string :manufacturer
      t.string :device
      t.string :brand
      t.string :user
      t.string :cpu
      t.string :sdk_int
      t.string :sdk_val
      t.string :release
      t.string :sdk_incremental
      t.string :gl_vendor
      t.string :gl_version
      t.string :gl_render

      t.timestamps null: false
    end
    add_index :devices, :uniq_id, unique: true
  end
end
