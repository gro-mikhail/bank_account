Rails.application.routes.draw do
  resources :bank_account_numbers, only: :create
  resources :clients, only: :create
end
