class NotifyTaxCloudOfRefundJob < ActiveJob::Base
  
  include Rollbar::ActiveJob
  
  queue_as :default
  
  def perform(payment)
    workflow = NotifiesTaxCloudOfRefund.new(payment)
    workflow.run
  end
end