class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :question, :course_id

  has_many :answers, dependent: :destroy
  belongs_to :course
  has_one :user, :through => :course
  has_one :settings, :through => :course

  def self.from_unpaused_courses
  	self.joins(:course).where(courses: { :paused_flag => 0 })
  end

  def answers_on_time
    data_array = self.answers.select('sum(CASE WHEN correct = 1 AND in_time = 1 THEN 1 ELSE 0 END) AS correct_in_time, 
                                                                  sum(CASE WHEN correct = 1 AND in_time = 0 THEN 1 ELSE 0 END) AS correct_out_time,
                                                                  SUM(CASE WHEN (correct = 0 OR correct IS NULL) AND in_time = 1 THEN 1 ELSE 0 END) AS incorrect_in_time,
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

  def average_response_time
    if !Rails.env.production?
      data_array = Question.find_by_sql("SELECT time_sent, SUM(time_diff) AS total_time_diff, sum(answers) AS total_answers
                                FROM (
                                    SELECT strftime('%m-%d', time_sent) AS time_sent,
                                            COUNT(*) AS answers,
                                            SUM(time_answered-time_sent) AS time_diff
                                    FROM answers
                                    WHERE time_answered IS NOT NULL
                                      AND question_id = #{self.id}
                                    GROUP BY strftime('%m-%d', time_sent)
                                )
                                GROUP BY time_sent")
    else
      data_array = Question.find_by_sql("SELECT time_sent, SUM(time_diff) AS total_time_diff, sum(answers) AS total_answers
                                FROM (
                                    SELECT DATE_FORMAT(time_sent, '%m-%d') AS time_sent,
                                            COUNT(*) AS answers,
                                            SUM(time_answered-time_sent) AS time_diff
                                    FROM answers
                                    WHERE time_answered IS NOT NULL
                                      AND question_id = #{self.id}
                                    GROUP BY DATE_FORMAT(time_sent, '%m-%d')
                                )
                                GROUP BY time_sent")
    end
    avg_response = Array.new
    data_array.each do |value|
      temp_array = Array.new
      temp_array << value.time_sent
      temp_array << (value.total_time_diff/value.total_answers).to_f

      avg_response << temp_array
    end

    return avg_response
  end

end
