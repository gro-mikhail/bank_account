class AccountsController < ApplicationController
  def create
    client = Client.find_by(identification_number: params[:identification_number])
    if client.nil?
      render json: { message: 'Сlient does not exist' }, status: 400
    else
      currency = params[:currency]&.upcase
      account = Account.new(client_id: client.id, currency: currency)
      if account.save
        render json: { account_number: account.account_number }, status: 201
      else
        render json: { message: account.errors.full_messages }, status: 400
      end
    end
  end
end
