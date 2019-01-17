class AddMapTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :map_type, :integer, default: 1 # 用百度地图解析坐标
  end
end
