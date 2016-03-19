class UsersController < ApplicationController
  before_action :verify_token, :only => [:update, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.create_by_params(user_params)

    if @user.errors.empty?
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    return unless @token_verified

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    return unless @token_verified
  
    @user.destroy
  end

  def authenticate
    token = User.authenticate_and_generate_new_token(params[:login], params[:password])
    if token 
      render json: token
    else
      render json: {:error => "Login or password don't match"}.to_json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:login, :hashed_password)
    end
end
