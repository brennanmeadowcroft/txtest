class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :question, :course_id

  has_many :answers, dependent: :destroy
  belongs_to :course
  has_one :user, :through => :course
  has_one :settings, :through => :course

  def self.from_unpaused_courses
  	self.find_by_sql("SELECT * FROM questions INNER JOIN courses ON questions.course_id = courses.id WHERE courses.paused_flag = 0")
  end
end
