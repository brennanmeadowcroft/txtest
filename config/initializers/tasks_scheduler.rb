# # http://kartzontech.blogspot.com/2011/02/no-more-cron-jobs-schedule-jobs-through.html
# require 'rufus/scheduler'  # Need this to make use of Rufus::Scheduler
# require 'rubygems'   # Need this to make use of any Gem, in our case it is rufus-scheduler
# require 'rake'

# scheduler = Rufus::Scheduler.start_new

# scheduler.every '1m' do  
# 	system "rake start_sending RAILS_ENV=#{Rails.env}"
# end
