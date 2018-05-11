class HomeController < ApplicationController
  def error_404
    render text: 'Not found', status: 404, layout: false
  end
  
  def install
    
  end
  
  def app_start
    @tasks = AwakeTask.where(opened: true).where('task_count != 0 and task_count > complete_count').order('sort desc, id desc')
  end
  
  def upload_awake_task_log
    task_id = params[:task_id]
    task = AwakeTask.find_by(uniq_id: task_id)
    
    if task.blank?
      re = 4004
    else
      AwakeTaskLog.create!(task_id: task.uniq_id, proj_id: task.project.try(:uniq_id), awake_source: params[:source])
      re = 1
    end
    render text: re
    
  end
  
end