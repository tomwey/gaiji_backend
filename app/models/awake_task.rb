class AwakeTask < ActiveRecord::Base
  validates :task_count, :proj_id, presence: true
  
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
  
end
