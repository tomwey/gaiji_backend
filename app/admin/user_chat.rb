ActiveAdmin.register UserChat do
  
  active_admin_import validate: true,
            template_object: ActiveAdminImport::Model.new(
                hint: "文件导入格式为: '聊天内容'",
                csv_headers: ["content"],
                force_encoding: :auto
            ),
            back: {action: :index}
            
menu parent: 'ds_menu', priority: 3, label: '聊天/评论内容管理'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
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

end
