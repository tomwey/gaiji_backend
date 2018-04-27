class UserNickname < ActiveRecord::Base
  validates :nickname, presence: true
  validates_uniqueness_of :nickname
end
