task :generate_schedule => :environment do
	courses = Course.unpaused_courses

	puts "#{courses.count} unpaused courses"

	courses.each do |course|
		course.generate_schedule
	end
end

task :send_texts => :environment do
	in_queue = Answer.to_send

	puts "#{in_queue.count} answers to send right now"

	in_queue.each do |answer|
		answer.send_text
	end
end