class CreditCard < ApplicationRecord

	belongs_to :user, dependent: :destroy

	validates_presence_of :user_id, :key, :credit_card_number
	validates_uniqueness_of :key, :scope => :user_id

	def as_json(options={})
  	{ id: self.id,
  		user_id: self.user_id,
  		key: self.key,
  		# credit_card_number: self.credit_card_number 
  	}
	end

	def self.create_by_params(password, credit_card_params)
		if credit_card_params[:credit_card_number] && !credit_card_params[:credit_card_number].empty?
			result = encrypted_value(credit_card_params[:credit_card_number], password)
			credit_card_params[:credit_card_number] = result
		end
    return CreditCard.create(credit_card_params)
	end

	def decrypted_credit_card(password)

	end

	def self.encrypted_value(value, password)
		cipher = Gibberish::AES.new(password)
		result = cipher.encrypt(value)
		return result
	end

	# params.require(:credit_card).permit(:user_id, :key, :credit_card_number)
 #    @credit_card = CreditCard.create_by_params(credit_card_params)
 #    @credit_card = CreditCard.new(credit_card_params)

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