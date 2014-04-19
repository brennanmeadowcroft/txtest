class Exam < ActiveRecord::Base
  attr_accessible :course_id, :user_id, :completed, :total_questions, :questions_correct, :time_limit, :time_taken, :test_started, :test_ended

  belongs_to :course
  belongs_to :user
  has_many :answers
  has_many :questions, :through => :answers

  def submit_results(form_inputs)
  	# Custom store method for handling all the questions that were asked in the exam

  	# Process each question asked
  	for i in form_inputs[:answers]
  		current = Answer.find(i.id)
  		current.submitted_answer = i.submitted_answer

  		# whether the question was answered in time is based on a hidden field in the form
  		current.in_time = i.in_time
  		current.exam_question_flag = 1

  		current.save
  	end

  	# Update the record with all the exam information
  	self.time_started = form_inputs[:time_started]
  	self.time_ended = Time.now()
  	self.time_taken = (self.time_ended-self.time_started)/60  # Get the number of minutes the test took
  	self.questions_correct = self.answers.where(:correct => 1)
  	self.completed = 1

  	self.save
  end

  def generate_test
  	# Generate all the questions to be used on the test
  	# Randomly select questions and ensure no duplicates.  Duplicates are fine on texts, not on an exam

  	# Get all questions
  	all_questions = self.course.questions
  	question_count = all_questions.count

    # Check that we have enough questions... if not, don't go any further
    if question_count >= self.total_questions

    	# Set the necessary base elements
    	test_questions = []
    	indices = []

    	# Loop through the total questions and generate the results
    	for i in 1..self.total_questions
    		random_num = rand(0..(question_count-1))

    		# Choose a random number the hasn't been selected yet
    		if !indices.include?(random_num)
    			indices << random_num
    		else
  	  		while indices.include?(random_num) do
  	  			random_num = rand(0..(question_count-1))
  	  		end
          indices << random_num
  	  	end

    		# Pull the selected question out of the
    		test_questions << all_questions[random_num]
    	end

    	# Create the questions in the database for the test
    	for q in test_questions
        if !q.nil?
          self.answers.create(:question_id => q.id)
        end
    	end
    else
      return nil
    end
  end

  def pct_correct(on_time_flag=1)
  	# Calculate the percent correct for the exam and return as a value
  	# By default, assumes that questions outside the time limit are incorrect.
  	# Marking on_time_flag=0 will return the correct % ignoring the time limit

  	if on_time_flag == 0
  		# Get correct answers regardless of time
  		correct = self.answers.where(:correct => 1).count
  	else
  		# Get correct answers answered on time
  		correct = self.answers.where(:correct => 1, :in_time => 1).count
  	end
  	total = self.total_questions

  	return correct/total
  end

  def pct_on_time(correct_flag=1)
  	# Calculate the percent answered on time for the exam and return as a value
  	# By default, assumes that user wants percent on time AND CORRECT.
  	# Marking correct_flag=0 will get the number of questions answered in time frame regardless of correctness

  	if correct_flag == 0
  		# Get answers on time regardless of correctness
  		on_time = self.answers.where(:in_time => 1).count
  	else
  		# Get the correct answers answered on time
  		on_time = self.answers.where(:in_time => 1, :correct => 1).count
  	end
  	total = self.total_questions

  	return on_time/total
  end
end
