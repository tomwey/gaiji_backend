ActiveAdmin.register TaskSourceLog do
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

filter :task_id, label: '任务ID'
filter :source,  label: '任务源'
filter :created_at, label: '创建时间'

actions :all, except: [:new, :create, :edit, :update]

index do
  selectable_column
  column('#',:id)
  column '任务ID', :task_id
  column '任务源', :source
  column '数据', :extra_data
  column 'at', :created_at
  
  actions
end

action_item only: :index do
  link_to '清空今天之前的数据', action: 'clear_data'
end

collection_action :clear_data, method: :get do
  date = (Time.zone.now - 1.days).strftime('%Y-%m-%d')
  TaskSourceLog.where('created_at < ?', Time.zone.now.beginning_of_day).update_all(visible: false)
  redirect_to collection_path, notice: "清空成功！"
end

controller do
  def scoped_collection
    end_of_association_chain.where(visible: true)
  end
  
  # def clear_data
  #   date = (Time.zone.now - 1.days).strftime('%Y-%m-%d')
  #   TaskSourceLog.where('date(created_at) = ?', date).update_all(visible: false)
  #   redirect_to collection_path, notice: "清空成功！"
  # end
end



end
