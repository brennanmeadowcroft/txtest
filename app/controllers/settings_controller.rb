class SettingsController < ApplicationController
	before_filter :signed_in_user
	
	def edit
		@setting = current_user.settings

		respond_to do |format|
			format.html
		end
	end

	def update
		@setting = current_user.settings

		respond_to do |format|
			if @setting.update_attributes(params[:settings])
				flash[:success] = "Your settings were successfully udpated"
				format.html { redirect_to current_user }
			else
				flash[:fail] = "There was a problem updating your settings"
				format.html { render action: "edit" }
			end
		end
	end
end
