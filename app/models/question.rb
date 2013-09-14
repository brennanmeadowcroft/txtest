class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :question, :course_id

  has_many :answers, dependent: :destroy
  belongs_to :course
  has_one :user, :through => :course
  has_one :settings, :through => :course
end
