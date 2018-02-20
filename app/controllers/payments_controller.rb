class PaymentsController < ApplicationController
  
  def show
    @payment = Payment.find_by(reference: params[:id])
  end
  
  def create
    token = StripeToken.new(**card_params)
    workflow = PurchasesCart.new(
      user: current_user, stripe_token: token,
      purchase_amount_cents: params[:purchase_amount_cents])
    workflow.run
    if workflow.success
      redirect_to payment_path(id: workflow.payment.reference)
    else
      redirect_to shopping_cart_path
    end
  end
  
  private
  
  def card_params
    params.permit(
      :credit_card_number, :expiration_month,
      :expiration_year, :cvc).to_h.symbolize_keys
  end
end