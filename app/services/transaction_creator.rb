class TransactionCreator
  attr_reader :errors

  def initialize(params)
    @amount = params[:amount].to_f
    @currency = params[:currency].upcase
    @sender_uid = params[:sender_uid]&.upcase
    @recipient_uid = params[:recipient_uid].upcase
    @transfer = transfer?
    @errors = []
  end

  def call
    data_validate
    return if @errors.any?

    transfer? ? create_transfer : top_up_an_account
  end

  private

  attr_reader :amount, :currency, :sender_uid, :recipient_uid

  def create_transfer
    ActiveRecord::Base.transaction do
      sender_account = account(sender_uid)
      sender_account.lock!
      recepient_account = account(recipient_uid)
      sender_account.update(balance: sender_account.balance - amount.to_f)
      sender_transaction = create_transaction(client_id: client_id(sender_uid), type: 'DOWN')
      recepient_account.update(balance: recepient_account.balance + amount.to_f)
      recepient_transaction = create_transaction(client_id: client_id(recipient_uid), type: 'UP')

      if !sender_account.valid? || !recepient_account.valid? || !recepient_transaction.valid? || !sender_transaction.valid?
        entities = [sender_account, sender_transaction, recepient_account, recepient_transaction]
        add_error(entities.compact.map { |e| e.errors.full_messages })
        raise ActiveRecord::Rollback
      end
    end
  end

  def top_up_an_account
    account = account(recipient_uid)
    account.update(balance: account.balance + amount.to_f)
    transaction = Transaction.new(transaction_data(client_id: client_id(recipient_uid), type: 'UP'))
    add_error(transaction.errors.full_messages) unless transaction.save
  end

  def transfer?
    sender_uid.present?
  end

  def account(uid)
    Account.find_or_create_by(client_id: client_id(uid), currency: currency)
  end

  def client_id(uid)
    Client.find_by(identification_number: uid)&.id
  end

  def add_error(text)
    @errors << text
  end

  def create_transaction(client_id:, type:)
    Transaction.create(transaction_data(client_id: client_id, type: type))
  end

  def transaction_data(client_id:, type:)
    {
      amount: amount,
      currency: currency,
      client_id: client_id,
      transaction_type: type,
      transfer: @transfer
    }
  end

  def data_validate
    add_error('Incorrect amount') unless amount.positive?
    add_error('Incorrect identification number!') if client_id(recipient_uid).nil?
    add_error('Incorrect identification number!') if transfer? && client_id(sender_uid).nil?
  end
end
