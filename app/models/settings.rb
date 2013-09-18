class Settings < ActiveRecord::Base
  attr_accessible :course_id, :texts_per_day, :start_time, :end_time, :response_time, :paused_flag

  belongs_to :course
  has_many :answers, :through => :course
  has_one :user, :through => :course

  validates :start_time, :inclusion => 0..23
  validates :end_time, :inclusion => 0..23, :numericality => { :greater_than => :start_time }

  before_create :init


  private
    def init
    	self.texts_per_day.nil? ? self.texts_per_day = 5 : self.texts_per_day
    	self.response_time.nil? ? self.response_time = 10 : self.response_time
    	self.start_time.nil? ? self.start_time = 9 : self.start_time
    	self.end_time.nil? ? self.end_time = 18 : self.end_time
    	self.paused_flag = 0
    end
end
