class JoinRemainTaskJob < ActiveJob::Base
  queue_as :scheduled_jobs
  
  def perform(task_id)
    @task = RemainTask.find_by(id: task_id)
    return if @task.blank?
    
    @task.generate_remain_tasks!
  end
end