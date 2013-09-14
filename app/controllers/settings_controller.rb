class SettingsController < ApplicationController
	before_filter :signed_in_user
	
	def show
		@setting = current_user.settings.find(params[:id])

		respond_to do |format|
			format.html
		end
	end

	def edit
		@setting = current_user.settings.find(params[:id])

		respond_to do |format|
			format.html
		end
	end

	def update
		@setting = current_user.settings.find(params[:id])

		respond_to do |format|
			if @setting.update_attributes(params[:settings])
				format.html { redirect_to @setting.course, notice: 'Setting was successfully updated.' }
			else
				format.html { render action: "edit" }
			end
		end
	end
end
