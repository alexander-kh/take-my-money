class PaymentsController < ApplicationController
  
  def show
    @payment = Payment.find_by(reference: params[:id])
  end
  
  def create
    workflow = create_workflow(params[:payment_type])
    workflow.run
    if workflow.success
      redirect_to workflow.redirect_on_success_url ||
        payment_path(id: workflow.payment.reference)
    else
      redirect_to shopping_cart_path
    end
  end
  
  private
  
  def create_workflow(payment_type)
    case payment_type
    when "paypal" then paypal_workflow
    else
      stripe_workflow
    end
  end
  
  def paypal_workflow
    PurchasesCartViaPayPal.new(
      user: current_user,
      purchase_amount_cents: params[:purchase_amount_cents],
      expected_ticket_ids: params[:ticket_ids])
  end
  
  def stripe_workflow
    PurchasesCartViaStripe.new(
      user: current_user,
      stripe_token: StripeToken.new(**card_params),
      purchase_amount_cents: params[:purchase_amount_cents],
      expected_ticket_ids: params[:ticket_ids])
  end
  
  def card_params
    params.permit(
      :credit_card_number, :expiration_month,
      :expiration_year, :cvc,
      :stripe_token).to_h.symbolize_keys
  end
end