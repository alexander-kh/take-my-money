Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root to: "visitors#index"
  devise_for :users
  resources :events
  resource :shopping_cart
  resource :subscription_cart
  resources :payments
  resources :users
  resources :plans
  resources :subscriptions
  resources :refunds
  
  get "paypal/approved", to: "pay_pal_payments#approved"
  
  post "stripe/webhook", to: "stripe_webhook#action"
end
