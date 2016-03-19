require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CreditCardsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # CreditCard. As you add validations to CreditCard, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CreditCardsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all credit_cards as @credit_cards" do
      user = User.create(login:"login", hashed_password: "hashed_password")
      credit_card = user.credit_cards.create(key: "key", credit_card_number: "credit_card_number")#, valid_attributes
      # credit_card.should be_valid
      # FactoryGirl.build(:user).should be_valid
      # credit_card.valid?
      # credit_card.errors.should have_key(:key)

      get :index, {}, valid_session
      # expect(assigns(:credit_cards)).to eq([credit_card])
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([{"id"=>1, "user_id"=>1, "key"=>"key"}])
    end
  end

  describe "GET show" do
    it "assigns the requested credit_card as @credit_card" do
      # credit_card = CreditCard.create! valid_attributes
      user = User.create(login:"login", hashed_password: "hashed_password")
      credit_card = user.credit_cards.create(key: "key", credit_card_number: "credit_card_number")#, valid_attributes
      get :show, {:id => credit_card.to_param}, valid_session
      # expect(assigns(:credit_card)).to eq(credit_card)
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq({"id"=>1, "user_id"=>1, "key"=>"key"})

    end
  end

  # describe "GET new" do
  #   it "assigns a new credit_card as @credit_card" do
  #     get :new, {}, valid_session
  #     expect(assigns(:credit_card)).to be_a_new(CreditCard)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested credit_card as @credit_card" do
  #     credit_card = CreditCard.create! valid_attributes
  #     get :edit, {:id => credit_card.to_param}, valid_session
  #     expect(assigns(:credit_card)).to eq(credit_card)
  #   end
  # end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CreditCard" do
        # expect {
        #   post :create, {:credit_card => valid_attributes}, valid_session
        # }.to change(CreditCard, :count).by(1)

        user = User.create(login:"login", hashed_password: "hashed_password")
        count = CreditCard.count
        post :create, {password: "romalopes", credit_card: {user_id: user.id, key: "key", credit_card_number: "credit_card_number"}}, valid_session

        expect(response).to be_success
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"id"=>1, "user_id"=>1, "key"=>"key"})
        
        expect(CreditCard.all.count).to eq(count + 1 )
      end

      it "assigns a newly created credit_card as @credit_card" do
        user = User.create(login:"login", hashed_password: "hashed_password")
        post :create, {password: "romalopes", credit_card: {user_id: user.id, key: "key", credit_card_number: "credit_card_number"}}, valid_session
        credit_card = CreditCard.last
        # expect(assigns(:credit_card)).to be_a(CreditCard)
        # expect(assigns(:credit_card)).to be_persisted
        expect(credit_card).to be_a(CreditCard)
        expect(credit_card).to be_persisted
      end

      it "redirects to the created credit_card" do
        user = User.create(login:"login", hashed_password: "hashed_password")
        post :create, {password: "romalopes", credit_card: {user_id: user.id, key: "key", credit_card_number: "credit_card_number"}}, valid_session
        # post :create, {:credit_card => valid_attributes}, valid_session
        # expect(response).to redirect_to(CreditCard.last)
        expect(response.status).to eq(201)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"id"=>1, "user_id"=>1, "key"=>"key"})
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved credit_card as @credit_card" do
        user = User.create(login:"login", hashed_password: "hashed_password")
        post :create, {password: "romalopes", credit_card: {user_id: user.id, key: "key"}}, valid_session
        parsed_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(parsed_response).to eq({"credit_card_number"=>["can't be blank"]})
        # post :create, {:credit_card => invalid_attributes}, valid_session
        # expect(assigns(:credit_card)).to be_a_new(CreditCard)
      end

      # it "re-renders the 'new' template" do
      #   post :create, {:credit_card => invalid_attributes}, valid_session
      #   expect(response).to render_template("new")
      # end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested credit_card" do
        user = User.create(login:"login", hashed_password: "hashed_password")
        credit_card = user.credit_cards.create(key: "key", credit_card_number: CreditCard.encrypted_value("credit_card_number", "romalopes")) #, valid_attributes

        # credit_card = CreditCard.create! valid_attributes
        # put :update, {:id => credit_card.to_param, :credit_card => new_attributes}, valid_session
        put :update, {:id => credit_card.to_param, :credit_card => {key: "key_1"}}, valid_session
        credit_card.reload
        expect(response.status).to eq(200)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"id"=>1, "user_id"=>1, "key"=>"key_1"})
        expect(credit_card.key).to eq("key_1")

        # skip("Add assertions for updated state")
      end

      # it "redirects to the credit_card" do
      #   user = User.create(login:"login", hashed_password: "hashed_password")
      #   credit_card = user.credit_cards.create(key: "key", credit_card_number: CreditCard.encrypted_value("credit_card_number", "romalopes")) #, valid_attributes
      #   put :update, {:id => credit_card.to_param, :credit_card => {key: "key_1"}}, valid_session
      #   expect(response).to redirect_to(credit_card)
      # end
    end

    describe "with invalid params" do
      it "assigns the credit_card as @credit_card" do
        user = User.create(login:"login", hashed_password: "hashed_password")
        credit_card = user.credit_cards.create(key: "key", credit_card_number: CreditCard.encrypted_value("credit_card_number", "romalopes")) #, valid_attributes

        put :update, {:id => credit_card.to_param, :credit_card => {credit_card_number: nil} }, valid_session
        expect(response.status).to eq(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"credit_card_number"=>["can't be blank"]})
        # expect(assigns(:credit_card)).to eq(credit_card)
      end

      # it "re-renders the 'edit' template" do
      #   credit_card = CreditCard.create! valid_attributes
      #   put :update, {:id => credit_card.to_param, :credit_card => invalid_attributes}, valid_session
      #   expect(response).to render_template("edit")
      # end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested credit_card" do
      user = User.create(login:"login", hashed_password: "hashed_password")
      credit_card = user.credit_cards.create(key: "key", credit_card_number: CreditCard.encrypted_value("credit_card_number", "romalopes")) #, valid_attributes
      expect {
        delete :destroy, {:id => credit_card.to_param}, valid_session
      }.to change(CreditCard, :count).by(-1)
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
    end

    # it "redirects to the credit_cards list" do
    #   user = User.create(login:"login", hashed_password: "hashed_password")
    #   credit_card = user.credit_cards.create(key: "key", credit_card_number: CreditCard.encrypted_value("credit_card_number", "romalopes")) #, valid_attributes
    #   delete :destroy, {:id => credit_card.to_param}, valid_session
    #   expect(response).to redirect_to(credit_cards_url)
    #   response.should redirect_to credit_cards_url
    # end
  end

end
