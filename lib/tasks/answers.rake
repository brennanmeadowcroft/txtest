task :generate_schedule => :environment do
	available_users = User.with_unpaused_courses

	puts "#{ available_users.count } users with unpaused courses"
	total_texts_today = 0
	users_without_questions = 0

	available_users.each do |user|
		total_texts = user.settings.texts_per_day
  		questions = user.questions.from_unpaused_courses

  		if questions.count > 0
  			total_texts_today += total_texts
			total_texts.times do |txt|
	  			random_num = rand(questions.count)
	  			random_question = questions[random_num]

	      		random_hour = rand(user.settings.start_time..user.settings.end_time)

				if random_hour == self.settings.end_time
					random_minute = 0
				else
					# Only send every five minutes
					minute_factor = rand(0..11)
					random_minute = minute_factor * 5
				end

				time_to_send = "%s %s:%02d -06:00" % [ Time.zone.now.strftime("%Y-%m-%d"), random_hour, random_minute ]
				# time_to_send = "%s %s:%02d" % [ Time.zone.now.strftime("%Y-%m-%d"), 21, 10 ]
				delay_time = ((Time.now.utc - time_to_send.to_datetime).to_i.abs)/60

				answer = Answer.create(:question_id => random_question.id, :time_sent => time_to_send)
				# answer.delay({:run_at => time_to_send, :queue => 'questions'}).send_text
				answer.delay({:run_at => delay_time.minutes.from_now, :queue => 'questions'}).send_text
			end
		else
			users_without_questions += 1
		end
  	end

  	puts "#{ users_without_questions } users have no questions to pick from!"
  	puts "#{ total_texts_today } texts to send today"
end

task :send_texts => :environment do
	in_queue = Answer.to_send

	puts "#{in_queue.count} answers to send right now"

	in_queue.each do |answer|
		answer.send_text
	end
end