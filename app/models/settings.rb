class Settings < ActiveRecord::Base
  attr_accessible :user_id, :texts_per_day, :start_time, :end_time, :response_time

  belongs_to :user

  validates :start_time, :inclusion => 0..23
  validates :end_time, :inclusion => 0..23, :numericality => { :greater_than => :start_time }

  after_initialize :init

  private
    def init
      self.texts_per_day ||= 5
      self.response_time ||= 10
      self.start_time ||= 9
      self.end_time ||= 18
    end
end
