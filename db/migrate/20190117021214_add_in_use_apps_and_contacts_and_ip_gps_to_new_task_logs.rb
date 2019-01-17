class AddInUseAppsAndContactsAndIpGpsToNewTaskLogs < ActiveRecord::Migration
  def change
    add_column :new_task_logs, :in_use_apps, :text # 当前设备安装的APP包名
    add_column :new_task_logs, :contacts, :text # 手机通讯录
    add_column :new_task_logs, :ip_gps, :string # 保存ip和gps坐标
    add_column :new_task_logs, :map_type, :integer # 坐标解析平台类型, 0 默认GPS坐标 1 百度 2 高德 3 腾讯
  end
end
