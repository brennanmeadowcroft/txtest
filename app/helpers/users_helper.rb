module UsersHelper
	def gravatar_for(user, custom_class=nil)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		custom_class.nil? ? css_class="gravatar" : css_class=custom_class
		image_tag(gravatar_url, alt: user.email, class: css_class)
	end
end
