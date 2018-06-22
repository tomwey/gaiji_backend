class AddDeviceInfoTypeAndLocalIpToPackets < ActiveRecord::Migration
  def change
    add_column :packets, :device_info_type, :string, default: 'DeviceInfo'
    add_column :packets, :local_ip, :string
    # add_index :packets, [:device_info_type, :device_info_id], name: 'device_info_typeable_idx'
  end
end
