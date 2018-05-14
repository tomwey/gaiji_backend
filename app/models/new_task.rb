class NewTask < ActiveRecord::Base
  validates :task_count, :task_date, :proj_id, presence: true
    
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
  
  def increment_complete_count
    self.class.increment_counter(:complete_count, self.id)
  end
  
  def project
    @project ||= Project.find_by(uniq_id: self.proj_id)
  end
  
  # 清空已做任务
  def clear_completed_tasks!
    NewTaskLog.where(task_id: self.uniq_id).delete_all
    self.complete_count = 0
    self.save!
  end
  
  TASK_TYPEs = [['默认', 0], ['唤醒', 1]]
  def task_type_name
    if self.task_type == 0
      return '默认'
    elsif self.task_type == 1
      return '唤醒'
    else
      return '未知任务'
    end
  end
  
end
