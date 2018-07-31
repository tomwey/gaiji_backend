ActiveAdmin.register NewTask do
  
  menu parent: 'rom_menu', priority: 4, label: '刷量任务'

  permit_params :proj_id, :task_count, :task_date, :opened, :task_type, :portal_urls_val, :remain_ratios

  index do
    selectable_column
    column('ID', :uniq_id)
    column '所属项目', sortable: false do |o|
      o.project.blank? ? '--' : link_to(o.project.try(:name), [:admin, o.project])
    end
    column :task_count
    column :complete_count
    column :task_date
    column '留存任务总数' do |o|
      o.remain_task_count
    end
    column '已做留存任务' do |o|
      o.remain_complete_count
    end
    column '任务类型' do |o|
      o.task_type_name
    end
    column :created_at
  
    actions defaults: false do |o|
      item "查看", admin_new_task_path(o)
      item "编辑", edit_admin_new_task_path(o)
      item "删除", admin_new_task_path(o), method: :delete, data: { confirm: '您确定吗？' }, class: 'btn btn-danger'
      if o.complete_count > 0
        item "清空已做任务", clear_admin_new_task_path(o), method: :put, data: { confirm: '你确定吗？' }, class: 'danger'
      end
      if o.remain_task_count > 0
        item "清空已做留存", clear2_admin_new_task_path(o), method: :put, data: { confirm: '你确定吗？' }, class: 'danger'
      end
    end
  end

  batch_action :clear do |ids|
    batch_action_collection.find(ids).each do |o|
      o.clear_completed_tasks!
    end
    redirect_to collection_path, alert: "已清空"
  end
  
  member_action :clear, method: :put do
    resource.clear_completed_tasks!
    redirect_to collection_path, notice: '清空成功'
  end
  
  batch_action :clear2 do |ids|
    batch_action_collection.find(ids).each do |o|
      o.clear_remain_tasks!
    end
    redirect_to collection_path, alert: "已清空留存"
  end
  
  member_action :clear2, method: :put do
    resource.clear_remain_tasks!
    redirect_to collection_path, notice: '留存清空成功'
  end

  form html: { multipart: true } do |f|
    f.semantic_errors
  
    f.inputs '基本信息' do
      f.input :proj_id, as: :select, label: '所属项目', collection: Project.where(opened: true).order('created_at desc').map { |p| [p.name, p.uniq_id] }, prompt: '-- 选择项目 --', required: true
      f.input :task_count, placeholder: '任务量'
      f.input :task_type, as: :select, label: '任务类型', collection: NewTask::TASK_TYPEs, required: true
      f.input :remain_ratios, label: '任务留存率', placeholder: '多天留存率使用英文逗号分隔,例如：50,30,10'
      f.input :task_date, as: :string, placeholder: '例如：2018-01-10', hint: '任务开始日期'
      f.input :opened, label: '是否开启'
      f.input :portal_urls_val, as: :text, label: '该任务入口地址', placeholder: '多个地址请用英文逗号(,)或竖线(|)分隔'
    end
    actions
  end

end
