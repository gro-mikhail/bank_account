class TransactionsController < ApplicationController
  def create
    transaction = TransactionCreator.new(transactions_params)
    transaction.call
    if transaction.errors.empty?
      render json: transaction, status: 200
    else
      render json: { message: transaction.errors.flatten.uniq }, status: 400
    end
  end

  private

  def transactions_params
    {
      amount: params[:amount],
      currency: params[:currency],
      sender_uid: params[:sender_uid],
      recipient_uid: params[:recipient_uid]
    }
  end
end
