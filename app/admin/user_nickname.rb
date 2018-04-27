ActiveAdmin.register UserNickname do
  
  active_admin_import validate: true,
            template_object: ActiveAdminImport::Model.new(
                hint: "文件导入格式为: '昵称'",
                csv_headers: ["nickname"],
                force_encoding: :auto
            ),
            back: {action: :index}

menu parent: 'ds_menu', priority: 2, label: '用户昵称信息'
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
