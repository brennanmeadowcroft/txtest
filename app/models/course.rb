class Course < ActiveRecord::Base
  attr_accessible :description, :user_id

  has_many :questions, dependent: :destroy
  has_one :settings, dependent: :destroy

  after_create :create_settings

  def create_settings
  	Settings.create(:course_id => self.id)
  end
end
