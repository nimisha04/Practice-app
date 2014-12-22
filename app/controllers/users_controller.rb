class UsersController < ApplicationController
 
 	def create_email_for_twitter
	    data = session["devise.omniauth_data"]
	    puts data
	    if TwitterUser.find_by(email:user_params[:email])
	    	puts "coming"
			verifier = ActiveSupport::MessageVerifier.new('secret')
			token = verifier.generate(user_params["email"])
			PracticeMailer.twitter_activation_link(user_params["email"], token).deliver
			flash[:notice] = I18n.t "devise.registrations.signed_up_but_unconfirmed"
			redirect_to root_path
        else
        	puts "not coming"
         	@twitter_user = TwitterUser.find_by(uid:data['uid'],provider:data['provider'])
            if @twitter_user
            	puts "inside if"
	            @twitter_user.email = user_params["email"]
	            @twitter_user.save!
	            verifier = ActiveSupport::MessageVerifier.new('secret')
	            token = verifier.generate(@twitter_user.email)
	            PracticeMailer.twitter_activation_link(@twitter_user.email, token).deliver
	            flash[:notice] = I18n.t "devise.registrations.signed_up_but_unconfirmed"
	            redirect_to root_path
            else
            	puts "inside else"
	            redirect_to root_path
	            flash[:danger] = "Failed to process your request, Please try again."
            end
        end
    end
	private

        def user_params
     		 params.require(:user).permit(:email)
   		end
    
end