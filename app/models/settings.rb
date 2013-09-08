class Settings < ActiveRecord::Base
  attr_accessible :course_id, :texts_per_day, :start_time, :end_time, :response_time, :paused_flag

  belongs_to :course

  validate :correct_start_time
  validate :correct_end_time
  validate :start_before_end

  before_create :init

  def init
  	self.texts_per_day.nil? ? self.texts_per_day = 5 : self.texts_per_day
  	self.response_time.nil? ? self.response_time = 10 : self.response_time
  	self.start_time.nil? ? self.start_time = 9 : self.start_time
  	self.end_time.nil? ? self.end_time = 6 : self.end_time
  	self.paused_flag = 0
  end

  private
    def correct_start_time
      if self.start_time < 0 || self.start_time > 23
        errors.add(:start_time, "must be within a 24 hour time frame (between 0 and 23)")
      end
    end

    def correct_end_time
      if self.end_time < 0 || self.end_time > 23
        errors.add(:end_time, "must be within a 24 hour time frame (between 0 and 23)")
      end
    end

    def start_before_end
      if self.start_time > self.end_time 
        errors.add(:start_time, "must be earlier than end time")
      end
    end
end
