Rails.application.routes.draw do
  resources :accounts, only: :create
  resources :clients, only: :create
  resources :transactions, only: :create
end
