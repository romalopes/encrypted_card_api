class CreditCardsController < ApplicationController
  before_action :verify_token#, :only => [:create, :update, :destroy]
  before_action :set_credit_card, only: [:update, :destroy]

  # GET /credit_cards
  def index
    return unless @token_verified

    @token_verified.user
    @credit_cards = @token_verified.user.credit_cards

     # render status 404
    render json: @credit_cards
  end

  # GET /credit_cards/1
  def show
    return unless @token_verified
    @credit_card = @token_verified.user.credit_cards.where("credit_cards.id = ?", params[:id]).first

    render json: @credit_card
  end

  # POST /credit_cards
  def create
    return unless @token_verified
    if params[:password].blank?
      render json: {:error => "Password can't not be emtpy"}.to_json, status: :unauthorized and return
    end

    credit_card = @token_verified.user.credit_cards.where(key: params[:key]).first 
    if credit_card
        render json: {error: "Credit Card #{params[:key]} already exists."}, status: :unprocessable_entity and return  
    else
      @credit_card = CreditCard.create_by_params(@token_verified, params[:password], params[:key], params[:credit_card_number])

      if @credit_card.save
        render json: @credit_card, status: :created, location: @credit_card
      else
        render json: @credit_card.errors, status: :unprocessable_entity
      end
    end
  end

  def create_or_update_card
    return unless @token_verified
    if params[:password].blank?
      render json: {:error => "Password can't not be emtpy"}.to_json, status: :unauthorized and return
    end

    @credit_card = @token_verified.user.credit_cards.where(key: params[:key]).first 
    if @credit_card
        if @credit_card.update_by_params(params[:password], params[:key], params[:credit_card_number])
          render json: {credit_card_number: params[:credit_card_number], token_time: @token_verified.updated_at}.to_json, status: :created #, location: @credit_card
        else
          render json: @credit_card.errors, status: :unprocessable_entity
        end
    else
      @credit_card = CreditCard.create_by_params(@token_verified, params[:password], params[:key], params[:credit_card_number])

      if @credit_card.save
        render json: @credit_card, status: :created, location: @credit_card
      else
        render json: @credit_card.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /credit_cards/1
  # def update
  #   puts "\n\n\n\n------ #{credit_card_params[:password]}, #{credit_card_params[:key]}, ---#{credit_card_params[:credit_card_number]}\n\n\n\n"
  #   return unless @token_verified

  #   if @credit_card.update_by_params(credit_card_params[:password], credit_card_params[:key], credit_card_params[:credit_card_number])
  #     render json: @credit_card
  #   else
  #     render json: @credit_card.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /credit_cards/1
  def destroy
    return unless @token_verified
    @credit_card.destroy
  end


  def delete_credit_card 
    return unless @token_verified

    @credit_card = @token_verified.user.credit_cards.where(key: params[:key]).first 
    if @credit_card
      @credit_card.destroy 
      render json: {success: "Credit card removed", token_time: @token_verified.updated_at}.to_json, status: :created #, location: @credit_card
    else
      render json: {:error => "Credit card not found.", token_time: @token_verified.updated_at}.to_json, status: :unprocessable_entity and return
    end
  end

  def retrieve_credit_card_number

    return unless @token_verified

    credit_card = @token_verified.user.credit_cards.where(key: params[:key]).first
    if credit_card.nil?
      render json: {:error => "Credit card not found."}.to_json, status: :unprocessable_entity and return
    end
    credit_card_number = credit_card.decrypted_credit_card(params[:password])
    if credit_card_number
      @token_verified.user.add_log("Retrieving Credit card number from #{credit_card.key}")
      render json: {:credit_card_number => credit_card_number, token_time: @token_verified.updated_at}.to_json, status: 200 and return
    else 
      render json: {:error => "Token not found or Credit Card could not be decrypted."}.to_json, status: :unprocessable_entity and return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def credit_card_params
      params.require(:credit_card).permit(:user_id, :key, :credit_card_number, :password)
    end
end
