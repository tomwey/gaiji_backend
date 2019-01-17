class CommApp < ActiveRecord::Base
  validates :name, :bundle_id, presence: true
end
