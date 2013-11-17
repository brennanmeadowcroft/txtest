class Course < ActiveRecord::Base
  attr_accessible :description, :user_id, :paused_flag

  has_many :questions, dependent: :destroy
  has_many :answers, :through => :questions
  belongs_to :user

  before_save { self.paused_flag ||= 0 }

  def self.unpaused_courses
    self.where(:paused_flag => 0)
  end

  def self.sent_answers
    data_array = self.find_by_sql("SELECT courses.description, COUNT(answers.id) AS answer_count
              FROM courses 
              LEFT JOIN questions
                ON(courses.id = questions.course_id)
              LEFT JOIN answers
                ON(questions.id = answers.question_id)
              GROUP BY courses.description")
    
    sent_answers_by_course = Array.new
    data_array.each do |value|
      temp_array = Array.new
      temp_array << value.description
      temp_array << value.answer_count

      sent_answers_by_course << temp_array
    end

    return sent_answers_by_course
  end

  def self.correct_over_time(user_id, course_id)
    time_range = 1.month.ago..Time.now
    if !Rails.env.production?
      data_array = self.joins(questions: :answers).
                        group(:question_id).
                        where('answers.time_sent' => time_range, 'courses.user_id' => user_id, 'courses.id' => course_id).
                        select("strftime('%m-%d', answers.time_sent) AS date_sent, 
                                          COUNT(answers.id) AS total_answers, 
                                          SUM(CASE WHEN answers.correct = 1 AND answers.in_time = 1 THEN 1 ELSE 0 END) AS total_correct")
    else
      data_array = self.joins(questions: :answers).
                        group(:question_id).
                        where('answers.time_sent' => time_range, 'courses.user_id' => user_id, 'courses.id' => course_id).
                        select("DATE_FORMAT(answers.time_sent, '%m-%d') AS date_sent, 
                                          COUNT(answers.id) AS total_answers, 
                                          SUM(CASE WHEN answers.correct = 1 AND answers.in_time = 1 THEN 1 ELSE 0 END) AS total_correct")
    end
    correct_over_time = Array.new
    data_array.each do |value|
      temp_array = Array.new
      temp_array << value.date_sent
#      temp_array << value.total_answers
 #     temp_array << value.total_correct

      correct_pct = (value.total_correct/value.total_answers).to_f
      temp_array << correct_pct

      correct_over_time << temp_array
    end

    return correct_over_time
  end

  def self.answers_on_time(user_id, course_id)
    data_array = self.joins(questions: :answers).
                      where('courses.user_id' => user_id, 'courses.id' => course_id).
                      select('sum(CASE WHEN correct = 1 AND in_time = 1 THEN 1 ELSE 0 END) AS correct_in_time, 
                              sum(CASE WHEN correct = 1 AND in_time = 0 THEN 1 ELSE 0 END) AS correct_out_time,
                              SUM(CASE WHEN correct = 0 AND in_time = 1 THEN 1 ELSE 0 END) AS incorrect_in_time,
                              SUM(CASE WHEN correct = 0 AND in_time = 0 THEN 1 ELSE 0 END) AS incorrect_out_time')

    answers_on_time = Array.new
    data_array.each do |value|
      temp_array = Array.new
      temp_array << value.correct_in_time
      temp_array << value.correct_out_time
      temp_array << value.incorrect_in_time
      temp_array << value.incorrect_out_time

      answers_on_time << temp_array
    end

    return answers_on_time
  end

  def self.enforce_plan_limits(max_courses)
    # Get all the unpaused courses
    unpaused_courses = self.where(:paused_flag => 0).order(id: :desc)

    # If the number exceeds the max provided, pause the last courses added
    if unpaused_courses.count > max_courses
      number_to_pause = unpaused_courses.count-max_courses

      number_to_pause.times do |i|
        current_course = unpaused_courses[i] #i starts at 0
        current_course.paused_flag = 1
        current_course.save
      end
    end
  end

  def unpaused_questions
    # Query unpaused questions from Course so that I can limit the results to a particular course rather than ALL unpaused questions
    self.questions.unpaused_questions
  end
end
