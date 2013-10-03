class StaticPageController < ApplicationController
	layout "public"
	
	def index
	end

	def faq
	end

	def pricing
	end

	def privacy_policy
	end

	def terms_of_service
	end

	def sitemap
		respond_to do |format|
			format.xml
		end
	end
end
