Rails.application.routes.draw do
  root to: "visitors#index"
  devise_for :users
  resources :events
  resource :shopping_cart
  resource :subscription_cart
  resources :payments
  resources :users
  resources :plans
  resources :subscriptions
  
  get "paypal/approved", to: "pay_pal_payments#approved"
  
  post "stripe/webhook", to: "stripe_webhook#action"
end
