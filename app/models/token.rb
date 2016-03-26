class Token < ApplicationRecord

	belongs_to :user, dependent: :destroy

	validates_presence_of :user_id, :token
	validates_uniqueness_of :token, :scope => :user_id

	def as_json(options={})
  	{ 
  		token: self.token,
  		token_time: self.updated_at
  	}
	end

	def self.create_token(user)
		if user
			return token = user.tokens.create(token: Token.generate_token(user.to_param))
		end
	end

	def self.get_token_and_touch(token_string)
		token = Token.where("token = ? and updated_at > ? ", token_string, Time.now - 30.minutes).first
		if token.present?
			token.update_column(:updated_at, Time.zone.now)
			return token 
		end
	end

	private
		def self.generate_token(user_id)
			generated_token = ""
			begin
				o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
				generated_token = (0...50).map { o[rand(o.length)] }.join
				tokens = Token.where(user_id: user_id, token: generated_token)
			end while tokens.count > 0
		
			return generated_token
		end

end

