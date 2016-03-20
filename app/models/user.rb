class User < ApplicationRecord

	has_many :credit_cards
	has_many :tokens
	validates_presence_of :login, :hashed_password
	
	def as_json(options={})
  	{ :login => self.login }
	end

	def self.create_by_params(login, password)
		if password.present? && !password.empty?
    	hashed_password = User.encrypted_value(password) 
    end
    return User.create(login: login, hashed_password: hashed_password)
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

