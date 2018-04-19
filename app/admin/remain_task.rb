ActiveAdmin.register RemainTask do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :proj_id, :ratio, :task_date

index do
  selectable_column
  column('ID', :uniq_id)
  column '所属项目', sortable: false do |o|
    o.project.blank? ? '--' : link_to(o.project.try(:name), [:admin, o.project])
  end
  column :ratio
  column :task_date
  column :need_task_count
  column :join_task_count
  column :created_at
  
  actions defaults: false do |o|
    item "查看", admin_remain_task_path(o)
    if o.join_task_count > 0
      item "清空已做任务", clear_admin_remain_task_path(o), method: :put, data: { confirm: '你确定吗？' }, class: 'danger'
    end
  end
end

batch_action :clear do |ids|
  batch_action_collection.find(ids).each do |o|
    o.clear_joined_tasks!
  end
  redirect_to collection_path, alert: "已清空选中任务"
end
member_action :clear, method: :put do
  resource.clear_joined_tasks!
  redirect_to collection_path, notice: '清空成功'
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs '基本信息' do
    f.input :proj_id, as: :select, label: '所属项目', collection: Project.where(opened: true).map { |p| [p.name, p.uniq_id] }, prompt: '-- 选择项目 --', required: true
    f.input :ratio, placeholder: '留存率整数值，例如：留存80%，那么填入值80'
    f.input :task_date, as: :string, placeholder: '例如：2018-01-10', hint: '对应留存率的刷单日期'
  end
  actions
end

end
