class Course < ActiveRecord::Base
  attr_accessible :description, :user_id, :paused_flag

  has_many :questions, dependent: :destroy
  has_many :answers, :through => :questions
  has_one :settings, dependent: :destroy
  belongs_to :user

  before_create :init

  def self.unpaused_courses
    self.where(:paused_flag => 0)
  end

  def init
    self.paused_flag = 0 
  end
end
