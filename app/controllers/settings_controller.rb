class SettingsController < ApplicationController
	def show
		@setting = Settings.find(params[:id	])

		respond_to do |format|
			format.html
		end
	end

	def edit
		@setting = Settings.find(params[:id])

		respond_to do |format|
			format.html
		end
	end

	def update
		@setting = Settings.find(params[:id])

		respond_to do |format|
			if @setting.update_attributes(params[:settings])
				format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
			else
				format.html { render action: "edit" }
			end
		end
	end
end
