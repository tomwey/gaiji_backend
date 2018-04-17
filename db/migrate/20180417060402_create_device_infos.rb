class CreateDeviceInfos < ActiveRecord::Migration
  def change
    create_table :device_infos do |t|
      t.integer :uniq_id
      t.string :board
      t.string :brand
      t.string :cpu
      t.string :cpu2
      t.string :device
      t.string :display
      t.string :fingerprint
      t.string :hardware
      t.string :product_model
      t.string :manufacturer
      t.string :model
      t.string :product
      t.string :bootloader
      t.string :host
      t.string :build_tags
      t.string :incremental

      t.timestamps null: false
    end
    add_index :device_infos, :uniq_id, unique: true
  end
end
