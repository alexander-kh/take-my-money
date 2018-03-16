class PaymentsController < ApplicationController
  
  def show
    @reference = params[:id]
    @payment = Payment.find_by(reference: @reference)
  end
  
  def create
    workflow = run_workflow(params[:payment_type], params[:purchase_type])
    if workflow.success
      redirect_to workflow.redirect_on_success_url ||
        payment_path(id: @reference || workflow.payment.reference)
    else
      redirect_to shopping_cart_path
    end
  end
  
  private
  
  def run_workflow(payment_type, purchase_type)
    case purchase_type
    when "SubscriptionCart"
      stripe_subscription_workflow
    when "ShoppingCart"
      payment_type == "paypal" ? paypal_workflow : stripe_workflow
    end
  end
  
  def stripe_subscription_workflow
    workflow = CreatesSubscriptionViaStripe.new(user: current_user,
      expected_subscription_id: params[:subscription_ids].first,
      token: StripeToken.new(**card_params))
    workflow.run
    workflow
  end
  
  def paypal_workflow
    PreparesCartForPayPal.new(
      user: current_user,
      purchase_amount_cents: params[:purchase_amount_cents],
      expected_ticket_ids: params[:ticket_ids])
    workflow.run
    workflow
  end
  
  def stripe_workflow
    @reference = Payment.generate_reference
    PreparesCartForStripeJob.perform_later(
      user: current_user,
      params: card_params,
      purchase_amount_cents: params[:purchase_amount_cents],
      expected_ticket_ids: params[:ticket_ids],
      payment_reference: @reference)
  end
  
  def card_params
    params.permit(
      :credit_card_number, :expiration_month,
      :expiration_year, :cvc,
      :stripe_token).to_h.symbolize_keys
  end
end