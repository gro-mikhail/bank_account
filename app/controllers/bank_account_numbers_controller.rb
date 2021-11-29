class BankAccountNumbersController < ApplicationController
  def create
    client = Client.find_by(identification_number: params[:identification_number])
    currency_type = params[:currency_type]
    bank_account_number = BankAccountNumber.new(client_id: client.id, currency_type: currency_type)
    if bank_account_number.save
      render json: { account_number: bank_account_number.account_number }, status: 201
    else
      render json: { message: bank_account_number.errors.full_messages }, status: 400
    end
  end
end
