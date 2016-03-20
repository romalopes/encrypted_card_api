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

RSpec.describe UsersController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all users as @users" do
      user = User.create(login: "user_master", hashed_password: User.encrypted_value("hashed_password"))
      token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
      get :index, {token: token.token}, valid_session
      # expect(assigns(:users)).to eq([user])
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq([{"login"=>"user_master"}])
    end

    it "assigns all users as not user_master" do
      user = User.create(login: "login", hashed_password: User.encrypted_value("hashed_password"))
      token = User.authenticate_and_generate_new_token("login", "hashed_password")
      get :index, {token: token.token}, valid_session
      # expect(assigns(:users)).to eq([user])
      expect(response.status).to eq(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq({"error" => "Only user master can do this action"})
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      
      user = User.create(login: "user_master", hashed_password: User.encrypted_value("hashed_password"))
      token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
      get :show, {token: token.token, :id => user.to_param}, valid_session
      # expect(assigns(:credit_card)).to eq(credit_card)
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq({"login"=>"user_master"})
    end


    it "assigns the requested user not user_master" do
      user = User.create(login: "login", hashed_password: User.encrypted_value("hashed_password"))
      token = User.authenticate_and_generate_new_token("login", "hashed_password")
      get :show, {token: token.token, :id => user.to_param}, valid_session
      # expect(assigns(:users)).to eq([user])
      puts "\n\n\n\n----------response.body:#{response.body}"
      expect(response.status).to eq(422)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq({"error" => "Only user master can do this action"})
    end
  end

  # describe "GET new" do
  #   it "assigns a new user as @user" do
  #     get :new, {}, valid_session
  #     expect(assigns(:user)).to be_a_new(User)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested user as @user" do
  #     user = User.create! valid_attributes
  #     get :edit, {:id => user.to_param}, valid_session
  #     expect(assigns(:user)).to eq(user)
  #   end
  # end

  describe "POST create" do

    describe "create user_master" do 
      it "creates a new User Master" do
        # expect {
        #   # post :create, {:user => valid_attributes}, valid_session
        #   post :create, {:user => {login: "login", hashed_password: "password"}}, valid_session
        # }.to change(User, :count).by(1)

        # user = User.last

        count = User.count
        post :create_user_master, {password: "hashed_password"}, valid_session

        expect(response).to be_success
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"login"=>"user_master"})
        
        last_user = User.last
        expect(last_user.as_json).to eq( {:login=>"user_master"})
        expect(User.all.count).to eq(count + 1 )
      end

      it "User Master already exists" do
        user = User.create(login:"user_master", hashed_password: User.encrypted_value("hashed_password"))
        count = User.count
        post :create_user_master, {password: "hashed_password"}, valid_session

        expect(response.status).to eq(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"error" => "User Master already exists"})
        
        last_user = User.last
        expect(last_user.as_json).to eq( {:login=>"user_master"})
        expect(User.all.count).to eq(count )
      end
    end

    describe "with valid params" do
      it "creates a new User" do
        # expect {
        #   # post :create, {:user => valid_attributes}, valid_session
        #   post :create, {:user => {login: "login", hashed_password: "password"}}, valid_session
        # }.to change(User, :count).by(1)

        # user = User.last

        user = User.create(login:"user_master", hashed_password: User.encrypted_value("hashed_password"))
        token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
        count = User.count
        post :create, {token: token.token, login: "login_2", password: "hashed_password"}, valid_session

        expect(response).to be_success
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"login"=>"login_2"})
        
        last_user = User.last
        expect(last_user.as_json).to eq( {:login=>"login_2"})
        expect(User.all.count).to eq(count + 1 )
      end

      it "assigns a newly created user as @user" do
        user = User.create(login:"login", hashed_password: User.encrypted_value("hashed_password"))
        token = User.authenticate_and_generate_new_token("login", "hashed_password")
        post :create, {token: token.token, login: "login_2", password:"hashed_password"}, valid_session
        user = User.last
        expect(user).to be_a(User)
        expect(user).to be_persisted

      end

      # it "redirects to the created user" do
      #   post :create, {:user => valid_attributes}, valid_session
      #   expect(response).to redirect_to(User.last)
      # end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        user = User.create(login:"user_master", hashed_password: User.encrypted_value("hashed_password"))
        token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
        user = User.create(login:"login", hashed_password: User.encrypted_value("hashed_password"))

        post :create, {token: token.token, user: {login: nil, password: nil}}, valid_session
        # expect(assigns(:user)).to be_a_new(User)
        parsed_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(parsed_response).to eq({"login"=>["can't be blank"], "hashed_password"=>["can't be blank"]})
      end

      # it "re-renders the 'new' template" do
      #   post :create, {:user => invalid_attributes}, valid_session
      #   expect(response).to render_template("new")
      # end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested user" do
        # user = User.create! valid_attributes
        # put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        # user.reload
        # skip("Add assertions for updated state")

        master_user = User.create(login:"user_master", hashed_password: User.encrypted_value("hashed_password"))
        user = User.create(login:"login", hashed_password: User.encrypted_value("hashed_password"))
        token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
        put :update, {token: token.token, :id => user.to_param, :user => {login: "login_1"}}, valid_session
        user.reload
        expect(response.status).to eq(200)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"login"=>"login_1"})
      end

      # it "assigns the requested user as @user" do
      #   user = User.create! valid_attributes
      #   put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
      #   expect(assigns(:user)).to eq(user)
      # end

      # it "redirects to the user" do
      #   user = User.create! valid_attributes
      #   put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
      #   expect(response).to redirect_to(user)
      # end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = User.create(login:"user_master", hashed_password: User.encrypted_value("hashed_password"))
        token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
        user = User.create(login:"login", hashed_password: User.encrypted_value("hashed_password"))

        put :update, {token: token.token, :id => user.to_param, :user => {login: nil}}, valid_session
        # expect(assigns(:user)).to eq(user)
        expect(response.status).to eq(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({"login"=>["can't be blank"]})
      end

      # it "re-renders the 'edit' template" do
      #   user = User.create! valid_attributes
      #   put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
      #   expect(response).to render_template("edit")
      # end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      # user = User.create! valid_attributes
      # expect {
      #   delete :destroy, {:id => user.to_param}, valid_session
      # }.to change(User, :count).by(-1)
      user = User.create(login:"user_master", hashed_password: User.encrypted_value("hashed_password"))
      token = User.authenticate_and_generate_new_token("user_master", "hashed_password")
      user = User.create(login:"login", hashed_password: User.encrypted_value("hashed_password"))
      expect {
        delete :destroy, {token: token.token, :id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
    end

    # it "redirects to the users list" do
    #   user = User.create! valid_attributes
    #   delete :destroy, {:id => user.to_param}, valid_session
    #   expect(response).to redirect_to(users_url)
    # end
  end

end
