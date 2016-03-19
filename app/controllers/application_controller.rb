class ApplicationController < ActionController::API

	def verify_token
		@token_verified = Token.get_token_and_touch(params[:token])
    if @token_verified.nil?
      render json: {:error => "Login or password don't match"}.to_json, status: :unauthorized
    end
  end

end
