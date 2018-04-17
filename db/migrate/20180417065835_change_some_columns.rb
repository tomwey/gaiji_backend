class ChangeSomeColumns < ActiveRecord::Migration
  def change
    remove_column :packets, :brand # 品牌
    remove_column :packets, :model # 手机型号
    remove_column :packets, :firmware # 手机固件
    remove_column :packets, :manufacturer # 厂商
    remove_column :packets, :product # 产品
    remove_column :packets, :device # 设备
    remove_column :packets, :board  # 主板
    remove_column :packets, :cpu # 手机CPU型号
    remove_column :packets, :hardware # 手机硬件
    remove_column :packets, :fingerprint # 指纹
    add_column :packets, :device_info_id, :integer, index: true
    add_column :packets, :screen_dpi, :integer
  end
end
