class PayPalPaymentsController < ApplicationController
  
  def approved
    workflow = ExecutesPayPalPayment.new(
      payment_id: params[:paymentId],
      token: params[:token],
      payer_id: params[:PayerID])
    workflow.run
    redirect_to payment_path(id: workflow.payment.reference)
  end
end