require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /users" do
    it "works! (now write some real specs)" do
    	user = User.create(login: "user_master", hashed_password: User.encrypted_value("hashed_password"))
      token, number_tries = User.authenticate_and_generate_new_token("user_master", "hashed_password")
      get users_path(token: token.token)
      expect(response).to have_http_status(200)
    end
  end
end
