module ApplicationHelper
  
  def mailer_options
    [["None", :electronic], ["Standard", :standard], ["Overnight", :overnight]]
  end
end
