class User < ApplicationRecord

	has_many :credit_cards
	has_many :tokens
	validates_presence_of :login, :hashed_password
	
	def as_json(options={})
  	{ :login => self.login }
	end

	def self.create_by_params(user_params)
		if user_params[:hashed_password] && !user_params[:hashed_password].empty?
    	user_params[:hashed_password] = User.encrypted_value(user_params[:hashed_password]) 
    end
    return User.create(user_params)
  end

	# https://github.com/mdp/gibberish#encrypting
	# Gibberish::MD5("somedata")
	#=> aefaf7502d52994c3b01957636a3cdd2
  def self.encrypted_value(value)
		Gibberish::MD5(value)
	end

	def self.authenticate_and_generate_new_token(login, password)
		user = User.where(login: login, hashed_password: encrypted_value(password)).first
		if user 
			return Token.create_token(user)
		end
	end
end

