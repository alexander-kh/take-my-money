Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root to: "visitors#index"
  
  resource :user_simulation, only: %i(create destroy)
  
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }
  
  devise_scope :user do
    post "users/sessions/verify" => "Users::SessionsController"
    get "users/sessions/two_factor" => "Users::SessionsController"
  end
  
  resources :events
  resource :shopping_cart
  resource :subscription_cart
  resources :payments
  resources :users
  resources :plans
  resources :subscriptions
  resources :refunds
  
  resource :daily_revenue_report
  
  get "paypal/approved", to: "pay_pal_payments#approved"
  
  post "stripe/webhook", to: "stripe_webhook#action"
end
