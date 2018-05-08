class RemainTask < ActiveRecord::Base
  validates :ratio, :task_date, :proj_id, presence: true
  
  before_create :generate_unique_id
  def generate_unique_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..6]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  after_create :join_task
  def join_task
    JoinRemainTaskJob.perform_later(self.id)
  end
  
  def project
    @project ||= Project.find_by(uniq_id: self.proj_id)
  end
  
  def task_count
    [self.need_task_count, self.join_task_count].min
  end
  
  def increment_complete_count
    self.class.increment_counter(:complete_count, self.id)
  end
  
  def generate_remain_tasks!
    # 计算需要加入的任务数
    total_count = NewTaskLog.where(created_at: self.task_date.beginning_of_day..self.task_date.end_of_day).count
    need_task_count = self.ratio >= 100 ? total_count : ( (total_count * ratio / 100.0).to_i + 8 ) # 默认多加8个
    
    join_count = 0
    
    # 添加任务
    @logs = NewTaskLog.order('RANDOM()').limit(need_task_count)
    @logs.each do |log|
      if RemainTaskLog.create(task_id: self.uniq_id, proj_id: log.proj_id, packet_id: log.packet_id)
        join_count = join_count + 1
      end
    end
    
    self.need_task_count = need_task_count
    self.join_task_count = join_count
    
    self.save!
    
  end
  
  # 清空加入的留存任务
  def clear_joined_tasks!
    RemainTaskLog.where(task_id: self.uniq_id).delete_all
    self.join_task_count = 0
    self.save!
  end
  
end
