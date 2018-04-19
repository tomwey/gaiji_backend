class TaskLog < ActiveRecord::Base
  validates :project_id, :packet_id, presence: true
  # belongs_to :project
  # belongs_to :packet
  
  before_create :generate_uniq_id
  def generate_uniq_id
    begin
      self.uniq_id = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def project
    @project ||= Project.find_by(uniq_id: self.project_id)
  end
  
  def packet
    @packet ||= Packet.find_by(uniq_id: self.packet_id)
  end
  
end
