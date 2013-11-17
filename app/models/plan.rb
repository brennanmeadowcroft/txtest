class Plan < ActiveRecord::Base
	attr_accessible :annual_plan, :name, :fee, :interval, :trial_period_days, :max_texts, :max_courses, :max_questions, :private_plan
	has_many :users

	before_create { self.private_plan ||= 0 }
	after_create :add_plan
#	after_update :update_plan
#	before_destroy :destroy_stripe_plan

	def self.public_plans
		where(:private_plan => 0)
	end
	def self.create_annual_plan(plan)
		annual_name = plan.name + " Annual"
		annual_fee = plan.fee*9 #Annual fee is buy 9, get 3 free
		annual_interval = 'year'
		annual_trial_period_days = plan.trial_period_days
		annual_max_texts = plan.max_texts
		annual_max_courses = plan.max_courses
		annual_max_questions = plan.max_questions
		
		Plan.create(:name => annual_name, 
  					:fee => annual_fee,
  					:interval => annual_interval,
  					:trial_period_days => annual_trial_period_days,
  					:max_texts => annual_max_texts,
  					:max_courses => annual_max_courses,
  					:max_questions => annual_max_questions,
  					:annual_plan => 1)
	end

	private
		def add_plan
			add_stripe_plan(self)
		end
		def update_plan
			save_stripe_plan(self)
		end
		def destroy_stripe_plan
			plan = Stripe::Plan.retrieve(self.id.to_s)
			plan.delete
		end
		def add_stripe_plan(plan)
			# Add the plan to the Stripe account to be able to charge fees
			if plan.annual_plan == 0 
				interval = 'month'
			else 
				interval = 'year'
			end

			add_plan = Stripe::Plan.create(
						:amount => plan.fee*100,
						:interval => interval,
						:name => plan.name,
						:currency => 'usd',
						:id => plan.id
					)
			if add_plan
				return true
			else
				return false
			end
		end
		def save_stripe_plan(plan)
			current_plan = Stripe::Plan.retrieve(plan.id.to_s)

			current_plan.name = plan.name
			current_plan.save
		end
end
