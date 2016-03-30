class UsersController < ApplicationController
  before_action :verify_token, :except => [:create_user_master, :authenticate]
  before_action :set_user, only: [:show, :update, :destroy]


  def create_user_master
    if User.where(login: "user_master").first 
      render json: {:error => "User Master already exists"}.to_json, status: :unprocessable_entity and return
    end
    @user = User.create_by_params("user_master", params[:password])#params.as_json["user"])

    if @user.errors.empty?
      render json: @user, status: :created, location: @user
    else
      puts "@user.errors:#{@user.errors.full_messages.join(",")}"
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # GET /users
  def index
    return unless @token_verified && verify_is_master

    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    return unless @token_verified && verify_is_master
    render json: @user
  end

  # POST /users
  def create
    return unless @token_verified && verify_is_master


    puts "\n\n-----values:#{params.values} keys:#{params.keys}   params.as_json:#{params.as_json}--   params.as_json[user]:#{params.as_json["user"]}  to_param:#{params.to_param}\n\n\n\n"
    # test_object.methods:[:keys, :key?, :has_key?, :values, :has_value?, :value?, :empty?, :include?, :as_json, 
    #:always_permitted_parameters, :always_permitted_parameters=, :==, :to_h, :to_unsafe_h, :to_unsafe_hash, 
    #:each_pair, :each, :converted_arrays, :permitted?, :permit!, :require, :required, :permit, :[], :[]=, :fetch, :slice, :slice!, :except, :extract!, 
    #:transform_values, :transform_values!, :transform_keys, :transform_keys!, :delete, :select, :select!, :keep_if, :reject, :reject!, :delete_if, :values_at, :dup, 
    #:merge, :stringify_keys, :inspect, :method_missing, :parameters, :permitted=, :fields_for_style?, :to_json, :blank?, :present?, :presence, :psych_to_yaml, :to_yaml,
    # :to_yaml_properties, :acts_like?, :duplicable?, :deep_dup, :in?, :presence_in, :to_param, :to_query, :instance_values, :instance_variable_names, :with_options,
    # :html_safe?, :`, :pretty_print, :pretty_print_cycle, :pretty_print_instance_variables, :pretty_print_inspect, :require_or_load, :require_dependency, :load_dependency, 
    #:unloadable, :try, :try!, :nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, :clone, :itself, :taint, :tainted?, :untaint, :untrust, :untrusted?,
    # :trust, :freeze, :frozen?, :to_s, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :
    #instance_variable_set, :instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :extend,
    # :display, :method, :public_method, :singleton_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :gem, :class_eval, :byebug, :debugger, :pretty_inspect, 
    #:suppress_warnings, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__]

    user = User.where(login: params[:login]).first 
    if user
        render json: {error: "User #{params[:login]} already exists."}, status: :unprocessable_entity and return  
    else
      @user = User.create_by_params(params[:login], params[:password])#params.as_json["user"])

      if @user.errors.empty?
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    return unless @token_verified && verify_is_master

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    return unless @token_verified && verify_is_master
    
    @user.destroy
  end

  def reset_authentication_tries
    return unless @token_verified && verify_is_master

    user = User.where(login: params[:login]).first 
    if user 
      user.update_attributes authentication_tries: 0
      user.add_log("User Master Reset authentication tries")
      render json: {:success => "User #{params[:login]} authentication tries was reset."}.to_json
    else
      render json: {:error => "User #{params[:login]} wasn't found."}.to_json, status: :unprocessable_entity
    end
  end

  def logs
    return unless @token_verified

    if verify_is_master
      user = User.where(login: params[:login]).first 
    else
      user = @token_verified.user
    end

    if user 
      logs = params[:number_logs].present? ? user.logs.last(params[:number_logs])  : user.logs
      render json: logs.to_json
    else
      render json: {:error => "User #{params[:login]} wasn't found."}.to_json, status: :unprocessable_entity
    end
  end

  def authenticate
    token, number_tries = User.authenticate_and_generate_new_token(params[:login], params[:password])

    if number_tries > 10
      render json: {:error => "You tried to login more than 10 times.  Asks user_master to reset your account."}.to_json, status: 401
    elsif token 
      render json: token
    else
      render json: {:error => "Login or password don't match"}.to_json, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:login, :password)
    end
end
