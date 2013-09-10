task :generate_schedule => :environment do
	courses = Course.unpaused_courses

	puts "#{courses.count} unpaused courses"

	courses.each do |course|
		course.generate_schedule
	end
end