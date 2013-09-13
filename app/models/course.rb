class Course < ActiveRecord::Base
  attr_accessible :description, :user_id

  has_many :questions, dependent: :destroy
  has_many :answers, :through => :questions
  has_one :settings, dependent: :destroy

  after_create :create_settings

  def self.unpaused_courses
    self.find_by_sql("SELECT a.* FROM courses AS a INNER JOIN settings AS b ON(a.id = b.course_id) WHERE b.paused_flag = 0")
  end

  def create_settings
  	Settings.create(:course_id => self.id)
  end

  def generate_schedule
  	total_texts = self.settings.texts_per_day

  	total_texts.times do |text|
  		questions = Question.all
  		random_num = rand(questions.count)
  		random_question = questions[random_num]

      random_hour_mt = rand(self.settings.start_time..self.settings.end_time)
      random_hour = random_hour_mt+6 # MST is 6 hours behind UTC... add 6 hours to correct for when it converts UTC -> MST

      if random_hour == self.settings.end_time
        random_minute = 0
      else
        random_minute = rand(0..60)
      end

      time_to_send = "%s %s:%02d" % [ Time.zone.now.strftime("%Y-%m-%d"), random_hour, random_minute ]

  		Answer.delay(:run_at => time_to_send, :queue => 'questions').create(:question_id => random_question.id)
  	end
  end
end
