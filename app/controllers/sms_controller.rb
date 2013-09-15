class SmsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def receive
		sender = params[:From]
		body = params[:Body]

		user = User.find_by_phone_number(sender)

		if user.nil?
			render :action => 'no_user.xml', :layout => false
		end

		if !body.match(/[Qq][0-9]{1,}/).nil?
			answer_id = body.scan(/[Qq][0-9]{1,}/).first.scan(/[0-9]{1,}/).first.to_i

			@answer = user.answers.find(answer_id)
			@answer.submit_response(body)
			
			render :action => 'receive.xml', :layout => false
		else
			render :action => 'no_answer_id.xml', :layout => false
		end
	end
end
