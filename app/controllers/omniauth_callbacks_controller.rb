class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
        @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])      
        if @user.present? 
            puts @user.username   
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]
            if @user && @user.errors.any?
                flash[:error]="Account not created because of: #{@user.errors.full_messages.join(", ")}"
                redirect_to new_user_registration_url            
            end
        end
	end

	def linkedin
        @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"])      
        if @user.present? 
            puts @user.username   
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
            set_flash_message(:notice, :success, :kind => "Linkedin") if is_navigational_format?
        else
            session["devise.linkedin_data"] = request.env["omniauth.auth"]
            if @user && @user.errors.any?
                flash[:error]="Account not created because of: #{@user.errors.full_messages.join(", ")}"
                redirect_to new_user_registration_url            
            end
        end
	end

    def twitter
        data = session["devise.omniauth_data"] = User.build_twitter_auth_cookie_hash(request.env["omniauth.auth"])
        user = User.find_for_twitter_oauth(data)
        if user.class == User
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
            sign_in_and_redirect user, :event => :authentication
          else
            flash[:error] = "You must add an email to complete your registration."
            @user = user
            render "users/add_email"
          end
      end
end