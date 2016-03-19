class Token < ApplicationRecord

	belongs_to :user, dependent: :destroy

	validates_presence_of :user_id, :token
	validates_uniqueness_of :token, :scope => :user_id

	def as_json(options={})
  	{ id: self.id,
  		user_id: self.user_id,
  		token: self.token,
  	}
	end

	def decrypted_token(password)

	end

	def self.generate_token(user_id)
		generated_token = ""
		begin
			o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
			generated_token = (0...50).map { o[rand(o.length)] }.join
			tokens = Token.where(user_id: user_id, token: generated_token)
		end while tokens.count > 0
		
		return generated_token
	end

	# params.require(:token).permit(:user_id, :key, :token_number)
 #    @token = CreditCard.create_by_params(token_params)
 #    @token = CreditCard.new(token_params)

end


# Encrypting

# cipher = Gibberish::AES.new('p4ssw0rd')
# cipher.encrypt("some secret text")
# # => Outputs a JSON string containing everything that needs to be saved for future decryption
# # Example:
# # '{"v":1,"adata":"","ks":256,"ct":"ay2varjSFUMUmtvZeh9755GVyCkWHG0/BglJLQ==","ts":96,"mode":"gcm",
# # "cipher":"aes","iter":100000,"iv":"K4ZShCQGL3UZr78y","salt":"diDUzbc9Euo="}'
# Decrypting

# cipher = Gibberish::AES.new('p4ssw0rd')
# cipher.decrypt('{"v":1,"adata":"","ks":256,"ct":"ay2varjSFUMUmtvZeh9755GVyCkWHG0/BglJLQ==","ts":96,"mode":"gcm","cipher":"aes","iter":100000,"iv":"K4ZShCQGL3UZr78y","salt":"diDUzbc9Euo="}')
# # => "some secret text"