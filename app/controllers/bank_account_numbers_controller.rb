class BankAccountNumbersController < ApplicationController
  def create
    client = Client.find_by(identification_number: params[:identification_number])
    if client.nil?
      render json: { message: 'Сlient does not exist' }, status: 400
    else
      currency = params[:currency].upcase
      bank_account_number = BankAccountNumber.new(client_id: client.id, currency: currency)
      if bank_account_number.save
        render json: { account_number: bank_account_number.id }, status: 201
      else
        render json: { message: bank_account_number.errors.full_messages }, status: 400
      end
    end
  end
end
