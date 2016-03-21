require 'rails_helper'

RSpec.describe CreditCard, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

	let(:credit_card) { FactoryGirl.create(:credit_card) }
	before do
		@user = User.create(login:"login", hashed_password: User.encrypted_value("romalopes"))
    @credit_card = @user.credit_cards.create(key:"key", credit_card_number: CreditCard.encrypted_value("credit_card_number_value", "romalopes"))
	end

  subject { @credit_card }
	it { should respond_to(:user_id) }
	it { should respond_to(:key) }
	it { should respond_to(:credit_card_number) }

	it { should be_valid }

	describe "when is invalid" do
    it { 
    	@credit_card.key = nil
    	should_not be_valid 
    }
	end

	describe "when verify credit_card" do
		it "credit_card is correct" do 
			credit_card_number = @credit_card.decrypted_credit_card("romalopes")
			# @credit.hashed_password
			expect(credit_card_number).to eq("credit_card_number_value")
		end

		it "password is incorrect" do 
			credit_card_number = @credit_card.decrypted_credit_card("romalopes1")
			expect(credit_card_number).to eq(nil)
		end

		it "decript is corect" do 
		end
	end
end


# def self.create_by_params(credit_card_params, password)
# 		if credit_card_params[:credit_card_number] && !credit_card_params[:credit_card_number].empty?
# 			result = encrypted_value(credit_card_params[:credit_card_number], password)
# 			credit_card_params[:credit_card_number] = result
# 		end
#     return CreditCard.create(credit_card_params)
# 	end

# 	def decrypted_credit_card(password)

# 	end

# 	def self.encrypted_value(value, password)