class PracticeMailer < ActionMailer::Base
	def twitter_activation_link(email,token)
		@to= email
		@token=token
    	mail(to: @to, subject: "Activate link")
	end
end
