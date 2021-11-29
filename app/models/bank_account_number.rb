class BankAccountNumber < ApplicationRecord
  belongs_to :client

  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :currency_type, presence: true, case_sensitive: false
  validates :client_id, presence: true
  validate :valid_currency_type, :valid_number_accounts_for_user

  before_validation :load_default_balance, :load_account_number
  before_save :format_data

  private

  NUMBER_RANGE = (1_000_000_000_000_000..9_999_999_999_999_999)

  def format_data
    self.currency_type = self.currency_type.upcase
  end

  def load_default_balance
    self.balance = 0.0 if self.new_record?
  end

  def load_account_number
    self.account_number = loop do
      number = rand(NUMBER_RANGE)
      break number unless BankAccountNumber.exists?(account_number: number)
    end
  end

  def valid_currency_type
    Money.new(1000, currency_type) rescue errors.add(:currency_type, "Incorrect currency type")
  end

  def valid_number_accounts_for_user
    if BankAccountNumber.exists?(client_id: self.client_id, currency_type: self.currency_type.upcase )
      errors.add(:currency_type, "An account in this currency exists")
    end
  end

end
