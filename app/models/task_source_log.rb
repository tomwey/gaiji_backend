class TaskSourceLog < ActiveRecord::Base
  
  def self.to_csv
    attributes = %w{id extra_data}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |log|
        csv << attributes.map{ |attr| log.send(attr) }
      end
      
    end
    
  end
    
end
