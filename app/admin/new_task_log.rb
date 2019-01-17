ActiveAdmin.register NewTaskLog do
  
  menu parent: 'rom_menu', priority: 41, label: '刷量任务明细'
  
  actions :all, except: [:new, :create, :edit, :update]
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

filter :uniq_id
filter :task_id
filter :proj_id
filter :extra_data
filter :created_at
filter :do_remain_at
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
  selectable_column
  column('ID', :id)
  column '流水号', :uniq_id
  column '项目/任务' do |o|
    raw("#{o.project.try(:name)}<br>#{o.task.try(:name)}")
  end
  column '设备身份信息' do |o|
    o.packet.blank? ? '--' : link_to(o.packet.imei, [:admin, o.packet])
  end
  column '手机通讯录' do |o|
    if o.contacts.present?
      raw("#{o.contacts.split(',').join('<br>')}"
    else
      ''
    end
  end
  column '附加数据' do |o|
    o.extra_data
  end
  column '已做留存时间', :do_remain_at
  column 'at', :created_at
  actions
  
end

end
