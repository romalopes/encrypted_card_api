require 'rails_helper'

RSpec.describe Token, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

	let(:token) { FactoryGirl.create(:token) }
	before do
		@user = User.create(login:"login", hashed_password: User.encrypted_value("romalopes"))
		@token = Token.create_token(@user)
	end

  subject { @token }
	it { should respond_to(:user_id) }
	it { should respond_to(:token) }

	it { should be_valid }

	describe "when creating token without user" do
    it { 
    	 token = Token.create_token(nil)
    	 expect(token).to eq(nil)
    }
	end

	describe "when generating token" do
    it { 
    	 generated_token = Token.generate_token(@user.to_param)
    	 expect(generated_token.size).to eq(50)
    }
	end

	describe "test if token " do 
		it "when it is valid" do
			previous_updated_at = @token.updated_at
			sleep(0.1)
			token = Token.get_token_and_touch(@token.token)
			expect(token.present?).to eq(true)
			expect(token.updated_at).not_to eq(previous_updated_at)
			token.updated_at.should be > previous_updated_at
		end

		it "when it is invalid" do
			token = Token.get_token_and_touch(@token.token + "not valid")
			expect(token.present?).to eq(false)
		end
	end

end