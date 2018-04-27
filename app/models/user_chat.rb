class UserChat < ActiveRecord::Base
  validates :content, presence: true
end
