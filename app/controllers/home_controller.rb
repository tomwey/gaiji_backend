class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:upload_task_log]
  
  def error_404
    render text: 'Not found', status: 404, layout: false
  end
  
  def install
    
  end
  
  def app_start
    @tasks = NewTask.where(opened: true, task_type: 1).where('task_count != 0 and task_count > complete_count').order('id desc')
  end
  
  def get_mobile
    tel = ROMUtils.create_tel_number
    render text: tel
  end
  
  def get_task_url
    @task = NewTask.find_by(uniq_id: params[:id])
    if @task.blank?
      render text: 'Not found', status: 404, layout: false
      return
    end
    
    render text: @task.portal_urls.sample
  end
  
  # post /task/upload_log
  # id=39393838&source=http://www.baidu.com&extra_data=13684043430
  def upload_task_log
    task_id = params[:task_id]
    task = NewTask.find_by(uniq_id: task_id)
    
    if task.blank?
      render text: 'Not found', status: 404, layout: false
      return
    end
    
    TaskSourceLog.create!(task_id:task.uniq_id, source: params[:source], extra_data: params[:extra])
    
    render text: '1'
  end
  
  def upload_awake_task_log
    task_id = params[:task_id]
    task = NewTask.find_by(uniq_id: task_id)
    
    if task.blank?
      re = 4004
    else
      # TODO: 每次取最新的一条数据进行操作，因为默认是先改机再进行APP唤醒
      log = NewTaskLog.where(task_id: task.uniq_id).order('created_at desc').first
      if log.blank?
        re = 4004
      else        
        log.extra_data = params[:source]
        log.save!
        # AwakeTaskLog.create!(task_id: task.uniq_id, proj_id: task.project.try(:uniq_id), awake_source: params[:source])
        re = 1
      end
    end
    render text: re
    
  end
  
end