require 'rails_helper'

RSpec.describe Token, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

	let(:token) { FactoryGirl.create(:token) }
	before do
		@user = User.create(login:"login", hashed_password: User.encrypted_value("romalopes"))
    @token = @user.tokens.create(token: Token.generate_token(@user.to_param))
	end

  subject { @token }
	it { should respond_to(:user_id) }
	it { should respond_to(:token) }

	it { should be_valid }

	describe "when generating token" do
    it { 
    	 generated_token = Token.generate_token(@user.to_param)
    	 expect(generated_token.size).to eq(50)
    }
	end

	describe "when verify token" do
		it "token is correct" do 
			# @credit.hashed_password
			# expect(CreditCard.encrypted_value("romalopes")).to eq(@credit.hashed_password)
		end

		it "password is incorrect" do 
			# expect(User.encrypted_value("romalopes_1")).not_to eq(@user.hashed_password)
		end
	end
end
