class Event < ActiveRecord::Base
  attr_accessible :user_id, :stripe_event_id, :stripe_customer_id, :stripe_time, :type, :sub_type, :action

  belongs_to :user

  after_create :update_user

  def self.create_from_stripe_id(event_id)
  	event_info = Stripe::Event.retrieve(event_id)
  	event_info.customer_id.present? ? customer_id = event_info.customer_id : customer_id = nil
  	type_array = event_info.type.split('.')
    create_timestamp = event_info.created
    event_date = '1/1/1970'.to_date + create_timestamp.seconds

  	if type_array.count == 3
  		event_type = type_array[0]
  		event_sub_type = type_array[1]
  		event_action = type_array[2]
  	else
  		event_type = type_array[0]
  		event_sub_type = nil
  		event_action = type_array[1]
  	end

	if event_type == 'charge' or event_type == 'customer'
		user = User.where(:customer_id => self.stripe_customer_id)
	end


  	event = Event.new(:user_id => user.id, 
  					:stripe_event_id => event_info.id, 
  					:stripe_customer_id => customer_id,
            :stripe_time => event_date.to_date,
  					:type => event_type,
  					:sub_type => event_sub_type,
  					:action => event_action)
    return event
  end

  private
  	def update_user
  		if self.type == 'customer' and self.action == 'failed'
  			self.user.problem_with_card
  		end
  	end
end
