class CreatePackets < ActiveRecord::Migration
  def change
    create_table :packets do |t|
      t.integer :uniq_id
      t.string :serial      # 序列号
      t.string :android_id  
      t.string :imei
      t.string :sim_serial  # 手机卡序列号
      t.string :imsi
      t.string :sim_country # 手机卡国家
      t.string :phone_number # 手机号
      t.string :carrier_id   # 运营商
      t.string :carrier_name # 运营商名字
      # t.string :carrier_code
      t.string :network_type # 网络类型
      t.string :phone_type   # 手机类型
      t.string :sim_state    # 手机卡状态
      t.string :mac_addr     # MAC地址
      t.string :bluetooth_mac # 蓝牙地址
      t.string :wifi_mac # 路由器MAC
      t.string :wifi_name # 路由器名字
      t.string :os_version # 系统版本号
      t.string :sdk_value  # 系统版本值
      t.string :sdk_int
      t.string :brand # 品牌
      t.string :model # 手机型号
      t.string :screen_size # 分辨率
      t.string :firmware # 手机固件
      t.string :manufacturer # 厂商
      t.string :product # 产品
      t.string :device # 设备
      t.string :board  # 主板
      t.string :cpu # 手机CPU型号
      t.string :hardware # 手机硬件
      t.string :fingerprint # 指纹
      t.timestamps null: false
    end
    add_index :packets, :uniq_id, unique: true
  end
end
