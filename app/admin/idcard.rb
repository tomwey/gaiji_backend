ActiveAdmin.register Idcard do
  
  active_admin_import validate: true,
            template_object: ActiveAdminImport::Model.new(
                hint: "文件导入格式为: '姓名','身份证号'",
                csv_headers: ["name","card_no"],
                force_encoding: :auto
            ),
            back: {action: :index}
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

# action_item :only => :index do
#   link_to 'Upload CSV', action: 'upload_csv'
# end
#
# collection_action :upload_csv do
#   render "admin/csv/upload_csv"
# end
#
# collection_action :import_csv, :method => :post do
#   CsvDb.convert_save("idcard", params[:dump][:file])
#   redirect_to collection_path, notice: 'Import uploaded successfully.'
# end

end
