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
    
    credit_card_params
    @credit_card = CreditCard.create_by_params(params[:password], credit_card_params)

    if @credit_card.save
      render json: @credit_card, status: :created, location: @credit_card
    else
      render json: @credit_card.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /credit_cards/1
  def update
    return unless @token_verified

    if @credit_card.update(credit_card_params)
      render json: @credit_card
    else
      render json: @credit_card.errors, status: :unprocessable_entity
    end
  end

  # DELETE /credit_cards/1
  def destroy
    return unless @token_verified

    @credit_card.destroy
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
