class Account < ApplicationRecord
  belongs_to :client

  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :currency, presence: true, case_sensitive: false, currency: true
  validates :client_id, presence: true, uniqueness: { scope: :currency, message: "An account in this currency exists" }

  before_validation :load_account_number

  private

  def load_account_number
    self.account_number = SecureRandom.uuid if self.new_record?
  end
end
