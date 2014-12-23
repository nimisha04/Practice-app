class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,:omniauth_providers => [:facebook, :linkedin, :twitter]

	validates :username, presence: true

	def self.find_for_facebook_oauth(auth)
	    
	    user = User.where(:provider => auth.provider, :uid => auth.uid).first
	    if user
	      puts "user has signed up/logged in fromw facebook on the site"
	      return user
	    else
	    	registered_user = User.where(:email => auth.info.email).first
	    	if registered_user
	    		if registered_user.image_url.blank? && auth.info.image.present?
	    			registered_user.update_attributes(provider:auth.provider,uid:auth.uid,image_url:auth.info.image)
	    		else
	        		registered_user.update_attributes(provider:auth.provider,uid:auth.uid)
	        	end
	        	puts "user found locally and also found on facebook, so user is already registered to site with signup"
	        	return registered_user        
	      	else
				puts "creating user from facebook auth"
				user = User.create(username:(auth.info.first_name+auth.info.last_name).downcase+rand(100..1000).to_s,
				provider:auth.provider,
				uid:auth.uid,
				email:auth.info.email,
				password:Devise.friendly_token[0,20],
				image_url: auth.info.image
				)
				puts "user created"
				return user
	      	end
	    end    
	end

	def self.find_for_linkedin_oauth(auth)
	    user = User.where(:provider => auth.provider, :uid => auth.uid).first
	    if user
	      puts "user has signed up/logged in from linkedin on the site"
	      return user
	    else
	    	registered_user = User.where(:email => auth.info.email).first
	    	if registered_user
	    		if registered_user.image_url.blank? && auth.info.image.present?
	    			registered_user.update_attributes(provider:auth.provider,uid:auth.uid,image_url:auth.info.image)
	    		else
	        		registered_user.update_attributes(provider:auth.provider,uid:auth.uid)
	        	end
	        	puts "user found locally and also found on linkedin, so user is already registered to site with signup"
	        	return registered_user        
	      	else
				puts "creating user from facebook auth"
				user = User.create(username:(auth.info.first_name+auth.info.last_name).downcase+rand(100..1000).to_s,
				provider:auth.provider,
				uid:auth.uid,
				email:auth.info.email,
				password:Devise.friendly_token[0,20],
				image_url: auth.info.image
				)
				puts "user created"
				return user
	      	end
	    end    
	end

	
	def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
	    user = User.where(:twitter_provider => auth[:provider], :twitter_uid => auth[:uid]).first
	    if user
	      puts "user exist in local database and already signup from twitter"
	      return user
	    else
	      user = TwitterUser.new(:uid=>auth[:uid],:provider=>auth[:provider],
	       :username=>auth[:username]+rand(100000..999999).to_s
	      )
	      user.save!
	      user
	    end
	  end

	def self.build_twitter_auth_cookie_hash data
		{
		  :provider => data.provider, :uid => data.uid,
		  :access_token => data.credentials.token, :access_secret => data.credentials.secret,
		  :username => data.extra.raw_info.screen_name,
		}
	end

end
