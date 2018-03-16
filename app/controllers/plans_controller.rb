class PlansController < ApplicationController
  
  def index
    @plans = Plan.active.all
  end
end