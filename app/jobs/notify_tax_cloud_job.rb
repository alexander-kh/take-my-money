class NotifyTaxCloudJob < ActiveJob::Base
  
  include Rollbar::ActiveJob
  
  queue_as :default
  
  def perform(payment)
    workflow = NotifiesTaxCloud.new(payment)
    workflow.run
  end
end