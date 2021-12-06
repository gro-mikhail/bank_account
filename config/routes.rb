Rails.application.routes.draw do
  resources :accounts, only: :create
  resources :clients, only: :create
  resources :transactions, only: :create

  namespace :reports do
    resources :replenishment_amount_by_currency, only: :create
    resources :avg_min_max_amount_transaction_by_tags, only: :create
    resources :sum_accounts_by_currency, only: :create
  end
end
