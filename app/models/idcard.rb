class Idcard < ActiveRecord::Base
  validates :name, :card_no, presence: true
  validates_uniqueness_of :card_no
end
