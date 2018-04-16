ActiveAdmin.register Project do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :icon, :bundle_id, :task_count, :task_started_at, :task_desc, :download_urls_val, :opened
#

index do
  selectable_column
  column('ID', :uniq_id)
  column :icon, sortable: false do |o|
    o.icon.blank? ? '' : image_tag(o.icon.url(:small), size: '32x32')
  end
  column :name, sortable: false
  column :bundle_id, sortable: false
  column :task_count
  column :complete_count
  column :task_started_at
  column :task_desc
  column :created_at
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs '基本信息' do
    f.input :name, placeholder: '输入项目名字'
    f.input :icon, hint: '图片格式为：jpg,jpeg,gif,png'
    f.input :bundle_id, placeholder: '输入项目包名或bundle id', required: true
    f.input :task_count, placeholder: '刷单任务量，整数'
    f.input :task_started_at, as: :string, placeholder: '输入的时间格式为：2017-01-01 12:00'
    f.input :task_desc, as: :text, placeholder: '描述该项目的刷量任务要求等等'
    f.input :download_urls_val, as: :text, label: '项目包下载地址', placeholder: '项目包下载地址或二维码图片地址，多个地址请用英文逗号分隔'
    f.input :opened
    # f.input :body, as: :text, input_html: { class: 'redactor' },
    #   placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
  end
  actions
end

end
