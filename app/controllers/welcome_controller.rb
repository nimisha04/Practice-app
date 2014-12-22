class WelcomeController < ApplicationController
  def index
  end

  def activate_twitter_user
        email=false
        signature = params[:signature]
        verifier = ActiveSupport::MessageVerifier.new('secret')
        token = verifier.generate(params[:email])
        if signature==token
            signature=token
            email = verifier.verify(signature)
        end
        if email
            twitter_user = TwitterUser.find_by(email:email)
            if twitter_user
                if (user=User.find_by(email:twitter_user.email))
                    user.twitter_uid = twitter_user.uid
                    user.twitter_provider = twitter_user.provider
                    user.save
                    twitter_user.destroy!
                    sign_in user, :event => :authentication
                    redirect_to root_path
                    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"                
                else
                    user = User.new(email:twitter_user.email, twitter_uid:twitter_user.uid, twitter_provider: twitter_user.provider, username:twitter_user.username, remote_image_url:twitter_user.image.gsub("http","https"), password: Devise.friendly_token[0,20],agree_tac:true)
                    user.save!
                    twitter_user.destroy!
                    sign_in user, :event => :authentication
					flash[:success]="Successfully! authenticated from twitter account"
                end
            else
                redirect_to root_path
                flash[:danger] = "User not found"
            end
        else
          redirect_to root_path
          flash[:danger] = "Invalid secret token"
        end
    end
end
