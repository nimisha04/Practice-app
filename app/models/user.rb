class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,:omniauth_providers => [:facebook, :linkedin]

	validates :username, presence: true

	def self.find_for_facebook_oauth(auth)
	    
	    user = User.where(:provider => auth.provider, :uid => auth.uid).first
	    if user
	      puts "user has signed up/logged in from facebook on the site"
	      return user
	    else
	    	registered_user = User.where(:email => auth.info.email).first
	    	if registered_user
	        	registered_user.update_attributes(provider:auth.provider,uid:auth.uid)
	        	puts "user found locally and also found on facebook, so user is already registered to site with signup"
	        	return registered_user        
	      	else
				puts "creating user from facebook auth"
				user = User.create(username:(auth.info.first_name+auth.info.last_name).downcase+rand(100..1000).to_s,
				provider:auth.provider,
				uid:auth.uid,
				email:auth.info.email,
				password:Devise.friendly_token[0,20]
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
	        	registered_user.update_attributes(provider:auth.provider,uid:auth.uid)
	        	puts "user found locally and also found on linkedin, so user is already registered to site with signup"
	        	return registered_user        
	      	else
				puts "creating user from facebook auth"
				user = User.create(username:(auth.info.first_name+auth.info.last_name).downcase+rand(100..1000).to_s,
				provider:auth.provider,
				uid:auth.uid,
				email:auth.info.email,
				password:Devise.friendly_token[0,20]
				)
				puts "user created"
				return user
	      	end
	    end    
	end
end
