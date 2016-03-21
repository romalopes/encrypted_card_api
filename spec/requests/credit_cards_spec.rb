require 'rails_helper'

RSpec.describe "CreditCards", :type => :request do
  describe "GET /credit_cards" do
    it "works! (now write some real specs)" do
    	user = User.create(login:"login", hashed_password: User.encrypted_value("hashed_password"))
      token, number_tries = User.authenticate_and_generate_new_token("login", "hashed_password")

      get credit_cards_path(token: token.token)
      expect(response).to have_http_status(200)
    end
  end
end
