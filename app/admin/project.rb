ActiveAdmin.register Project do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
menu parent: 'rom_menu', priority: 3, label: '项目管理'

permit_params :name, :icon, :bundle_id, :task_count, :task_started_at, :task_desc, :download_urls_val, :opened, :awake_urls_val, :need_gps, :need_comm_app, :need_contacts
#

index do
  selectable_column
  column('ID', :uniq_id)
  column :icon, sortable: false do |o|
    o.icon.blank? ? '' : image_tag(o.icon.url(:small), size: '32x32')
  end
  column :name, sortable: false
  column :bundle_id, sortable: false
  # column :task_count
  # column :complete_count
  # column :task_started_at
  column :need_gps
  column :need_comm_app
  column :need_contacts
  
  column :task_desc
  column '唤醒地址' do |o|
    raw o.awake_urls.join('<br>')
  end
  column :created_at
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs '基本信息' do
    f.input :name, placeholder: '输入项目名字'
    f.input :bundle_id, placeholder: '输入项目包名或bundle id', required: true
    f.input :need_gps
    f.input :need_comm_app
    f.input :need_contacts
    f.input :task_count, placeholder: '刷单任务量，整数'
    f.input :icon, hint: '图片格式为：jpg,jpeg,gif,png'
    f.input :task_started_at, as: :string, placeholder: '输入的时间格式为：2017-01-01 12:00'
    f.input :task_desc, as: :text, placeholder: '描述该项目的刷量任务要求等等'
    f.input :awake_urls_val, as: :text, label: '唤醒地址', placeholder: '多个地址请用【英文逗号(,)，竖线(|)或换行】分隔'
    f.input :download_urls_val, as: :text, label: '项目包下载地址', placeholder: '项目包下载地址或二维码图片地址，多个地址请用英文逗号分隔'
    f.input :opened
    # f.input :body, as: :text, input_html: { class: 'redactor' },
    #   placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
  end
  actions
end

end
