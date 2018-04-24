class StripeCharge
  
  attr_accessor :token, :payment, :response, :error
  
  def self.charge(token:, payment:)
    StripeCharge.new(token: token, payment: payment).charge
  end
  
  def initialize(token:, payment:)
    @token = token
    @payment = payment
  end
  
  def charge
    return if response.present?
    @response = Stripe::Charge.create(
      {amount: payment.price.cents, currency: "usd",
       source: token.id, description: "",
       metadata: {reference: payment.reference}},
      idempotency_key: payment.reference)
  rescue Stripe::StripeError => e
    @response = nil
    @error = e
  end
  
  def charge_parameters
    parameters = {
      amount: payment.price.cents, currency: "usd",
      source: token.id, description: "",
      metadata: {reference: payment.reference}}
    if payment.active_affiliate.present?
      parameters[:destination] = payment.affiliate.stripe_id
      parameters[:application_fee] = payment.application_fee.cents
    end
    parameters
  end
  
  def success?
    response || !error
  end
  
  def payment_attributes
    success? ? success_attributes : failure_attributes
  end
  
  def success_attributes
    {status: :succeeded,
     response_id: response.id, full_response: response.to_json}
  end
  
  def failure_attributes
    {status: :failed, full_response: error.to_json}
  end
end