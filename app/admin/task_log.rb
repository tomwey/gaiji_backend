ActiveAdmin.register TaskLog do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

actions :all, except: [:new, :create]

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
  column('ID', :uniq_id)
  column '项目', sortable: false do |o|
    o.project.try(:name)
  end
  column '改机数据', sortable: false do |o|
    link_to o.packet.uniq_id, [:admin, o.packet]
  end
  column '留存率使用情况', :remain_ratios, sortable: false
  actions
end

end
