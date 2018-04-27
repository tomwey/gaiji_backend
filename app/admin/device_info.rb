ActiveAdmin.register DeviceInfo do
  active_admin_import validate: true,
            template_object: ActiveAdminImport::Model.new(
                hint: "文件导入格式为: '主板','品牌','CPU','CPU2','驱动','显示','指纹','硬件','产品型号','生产商','型号','产品','启动引导','HOST','编译标记','Incremental'",
                csv_headers: ["board","brand","cpu","cpu2","device","display","fingerprint","hardware","product_model","manufacturer","model","product","bootloader","host","build_tags","incremental"],
                force_encoding: :auto
            ),
            back: {action: :index}
  
menu parent: 'rom_menu', priority: 1, label: '设备信息'
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
