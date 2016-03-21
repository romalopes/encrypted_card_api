require 'rails_helper'

RSpec.describe User, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:user) { FactoryGirl.create(:user) }
	before do
		@user = User.create(login:"login_1", hashed_password: User.encrypted_value("romalopes"))
	end

  subject { @user }
	it { should respond_to(:login) }
	it { should respond_to(:hashed_password) }

	it { should be_valid }

	describe "when is invalid" do
    it { 
    	@user.login = nil
    	should_not be_valid 
    }

	end

	describe "create by params" do 
		it "params ok" do 
			# user_params = {login: "login", password: "password"}
			count = User.count
			user = User.create_by_params("login", "password")
			expect(user.errors.empty?).to eq(true)
		end
		it "params no login" do 
			# user_params = {login: nil, hashed_password: "password"}
			count = User.count
			user = User.create_by_params(nil, "password")
			expect(user.errors.empty?).to eq(false)
			user.valid?
      user.errors.should have_key(:login)
		end
	end

	describe "when verify password" do
		it "password is correct" do 
			expect(User.encrypted_value("romalopes")).to eq(@user.hashed_password)
		end

		it "password is incorrect" do 
			expect(User.encrypted_value("romalopes_1")).not_to eq(@user.hashed_password)
		end
	end

	describe "when try to authenticate" do 
		it "successful" do 
			token, number_tries = User.authenticate_and_generate_new_token("login_1", "romalopes")
			expect(token).not_to eq(nil)
			expect(token.token.size).to eq(50)
		end

		it "fail" do 
			token, number_tries = User.authenticate_and_generate_new_token("login_1", "romalopes1")
			expect(token).to eq(nil)
		end

		it "fail" do 
			token, number_tries = User.authenticate_and_generate_new_token("login_1", "romalopes1")
			expect(token).to eq(nil)
			expect(number_tries).to eq(1)
		end

	end

end