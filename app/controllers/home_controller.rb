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
  
  def get_idcard
    
    if params[:cl] && params[:cl].to_i == 1
      $redis.del 'queued'
      render text: '数据缓存已清空'
      return
    end
    
    flag = (params[:flag] || 0).to_i
    
    unless %w(0 1).include? flag.to_s
      render text: 'flag参数不正确，只能为0或1'
      return
    end
    
    queued = $redis.get('queued')
    ids = []
    if queued.present?
      ids = queued.split(',')
    end
    if flag == 1
      @idcard = Idcard.where.not(card_no: ids).order('RANDOM()').first
    else
      @idcard = Idcard.order('RANDOM()').first
    end
    
    if @idcard.blank?
      render text: '无更多数据了', status: 404
      return
    end
    
    if flag == 1
      ids << @idcard.card_no
      $redis.set 'queued', ids.join(',')
    end
    
    render text: "#{@idcard.name},#{@idcard.card_no}"
  end
  
  def get_task_url
    @task = NewTask.find_by(uniq_id: params[:id])
    if @task.blank?
      render text: 'Not found', status: 404, layout: false
      return
    end
    
    render text: @task.portal_urls.sample
  end
  
  def get_company
    arr = []
    File.open("/data/www/apps/gaiji_backend_production/shared/config/companies.txt").each { |line| arr << line }
    render text: arr.sample
  end
  
  def export_csv
    if params[:url].blank? and params[:task_id].blank? 
      render text: 'Not Found', status: 404
      return
    end
    
    @data = TaskSourceLog.order('id desc')
    if params[:task_id]
      @data = @data.where(task_id: params[:task_id])
    end
    if params[:url]
      @data = TaskSourceLog.where(source: params[:url])
    end
    
    # @data = TaskSourceLog.where(source: params[:url]).order('id desc')
    prefix = ''
    if params[:begin_date] and params[:end_date]
      @data = @data.where('created_at between ? and ?', params[:begin_date], params[:end_date])
      prefix = "#{params[:begin_date]}-#{params[:end_date]}"
    else
      if params[:date]
        @data = @data.where('DATE(created_at) = ?', params[:date])
        prefix = "#{params[:date]}"
      end
    end
    
    if @data.blank? or @data.empty?
      render text: 'No data', status: 404
      return 
    end
    
    respond_to do |format|
      suffix = ''
      if params[:url] 
        if params[:url].include? '?'
          _,suffix = params[:url].split('?')
          _,suffix = suffix.split('=')
        else
          suffix = params[:url]
        end
      else
        suffix = params[:task_id]
      end
      
      format.csv { send_data @data.to_csv, filename: "#{prefix}_#{suffix}.csv" }
    end
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
    
    extra = params[:extra]
    source = params[:source]
    
    params.delete 'extra'
    params.delete 'task_id'
    params.delete 'source'
    params.delete 'controller'
    params.delete 'action'
    
    if source
      str = ''
      params.each do |k,v|
        str += "&#{k}=#{v}"
      end
      source += str
    end
    
    TaskSourceLog.create!(task_id:task.uniq_id, source: source, extra_data: extra)
    
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