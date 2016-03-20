class ApplicationController < ActionController::API

	def verify_token
		puts "\n\n\nparams[:token]:#{params[:token]}----  params:#{params.values} "
		@token_verified = Token.get_token_and_touch(params[:token])
    if @token_verified.nil?
      render json: {:error => "Token not found"}.to_json, status: :unauthorized
    end
  end

	def verify_is_master
		if @token_verified.user.login != "user_master"
      render json: {:error => "Only user master can do this action"}.to_json, status: :unprocessable_entity and return false
    end
    return true
  end



end
